import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../data_manager/data_manager.dart';
import '../notification_manager/norification_manager.dart';
import '../../models/sensorConfigMatcher/sensor_config_matcher.dart';
import '../../models/StatusMatcher/status_matcher.dart';
import '../../models/navigationMatcher/navigation_matcher.dart';
import '../../models/sensorConfigModel/sensor_config.dart';
import '../sensor_config_manager/sensor_config_manager.dart';

/// Class: InfluxDBService
/// Author: Giacomo Gargula
/// This service is responsible for retrieving the initial data from InfluxDB 
/// and storing it in the global data list (managed by the Data Manager). 
/// The service is executed only at the startup of the application, fetching the 
/// latest 1000 data points for all measurements.
class InfluxDBService {
  static final logger = Logger();
  static const String influxUrl = 'http://localhost:8086/query'; // URL for the InfluxDB connection
  static const String dbName = 'openhab_db'; // Name of the database (bucket) where the data is stored
  static const String username = 'admin';  // Username for InfluxDB 
  static const String password = '123abc';  // Password for InfluxDB

   // Measurements from different boards and sensors
  static const List<String> measurements = [
    'board1_amb_press',
    'board1_co',
    'board1_co2',
    'board1_humid1_am',
    'board1_humid2_am',
    'board1_humid3_am',
    'board1_humid4_am',
    'board1_o2',
    'board1_o3',
    'board1_temp1_am',
    'board1_temp2_am',
    'board1_temp3_am',
    'board1_temp4_am',
    'board2_amb_press',
    'board2_co',
    'board2_co2',
    'board2_humid1_am',
    'board2_humid2_am',
    'board2_humid3_am',
    'board2_humid4_am',
    'board2_o2',
    'board2_o3',
    'board2_temp1_am',
    'board2_temp2_am',
    'board2_temp3_am',
    'board2_temp4_am',
    'board3_amb_press',
    'board3_co',
    'board3_co2',
    'board3_humid1_am',
    'board3_humid2_am',
    'board3_humid3_am',
    'board3_humid4_am',
    'board3_o2',
    'board3_o3',
    'board3_temp1_am',
    'board3_temp2_am',
    'board3_temp3_am',
    'board3_temp4_am',
    'board4_amb_press',
    'board4_co',
    'board4_co2',
    'board4_humid1_am',
    'board4_humid2_am',
    'board4_humid3_am',
    'board4_humid4_am',
    'board4_o2',
    'board4_o3',
    'board4_temp1_am',
    'board4_temp2_am',
    'board4_temp3_am',
    'board4_temp4_am',
    'pbr1_amb_press_2',
    'pbr1_co2_2',
    'pbr1_do',
    'pbr1_o2_2',
    'pbr1_od',
    'pbr1_ph',
    'pbr1_rh_2',
    'pbr1_temp_g_2',
    'pbr1_temp_l'
  ];

  // Data storage: Map to hold fetched data per measurement
  static final Map<String, List<Map<String, dynamic>>> fetchedData = {};

/// Fetches data from InfluxDB for all defined measurements.
///
/// This method queries the InfluxDB database to retrieve the latest 1000 records
/// for each defined measurement. It processes and normalizes the retrieved data
/// and formats timestamps to maintain consistency with the application's format.
/// The fetched data is stored in the application's [DataManager].
///
/// **Parameters:**  
/// - No parameters. Measurements and InfluxDB connection details are predefined.
///
/// **Returns:**  
/// - A [Future<void>] that completes when data fetching is finished for all measurements.
  static Future<void> fetchData() async {
  for (var measurement in measurements) {
    final query = 'SELECT * FROM $measurement LIMIT 1000';
    final url = Uri.parse('$influxUrl?db=$dbName&q=$query');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$username:$password'))}'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final series = data['results'][0]['series'];

        if (series != null && series.isNotEmpty) {
          final rows = series[0]['values'];
          final columns = series[0]['columns'];

          if (columns is List<dynamic>) {
            final List<String> keys = columns.map((e) => e.toString()).toList();

            
            final fetchedData = rows
                .where((row) => row is List)
                .map<Map<String, dynamic>>((row) {
              final List<dynamic> values = row;

              
              final Map<String, dynamic> dataMap =
                  Map<String, dynamic>.fromIterables(keys, values);
              if (dataMap.containsKey('time')) {
                dataMap['time'] = _normalizeTimestamp(dataMap['time']);
              }
              return dataMap;
            }).toList();

            DataManager().addData(measurement, fetchedData);
          } else {
            throw Exception('Unexpected columns type: ${columns.runtimeType}');
          }
        } else {
          print('Keine Daten für $measurement gefunden.');
        }
      } else {
        print('Fehler beim Abrufen von $measurement: ${response.body}');
      }
    } catch (e) {
      print('Exception beim Abrufen von $measurement: $e');
    }
  }
  logger.i('All data has been successfully fetched from influxdb');
}

/// Processes the latest sensor values and creates notifications during app startup.
///
/// This method retrieves the latest values for all predefined measurements,
/// checks their status based on sensor configurations, and generates notifications
/// if necessary. It ensures the app has an up-to-date status for all monitored sensors.
///
/// **Parameters:**
/// - [context]: The current [BuildContext], used to access the [NotificationManager].
static Future<void> processLatestValuesOnStartup(BuildContext context) async {
    final manager = Provider.of<NotificationManager>(context, listen: false);
    final dataManager = DataManager();
    final sensorConfigManager = SensorConfigManager();
    final configs = await sensorConfigManager.loadConfigs();

    for (String measurement in measurements) {
      
      final latestValue = dataManager.getLatestValue(measurement);
      if (latestValue == 'N/A') {
        print('Keine Daten für $measurement verfügbar.');
        continue;
      }

     
      final sensorConfigName = SensorConfigMatcher.getSensorConfigName(measurement);
      final sensorRoute = NavigationMatcher.getRoute(measurement);
      final sensorType = StatusMatcher.getSensorStatusType(measurement);

      if (sensorConfigName != null && sensorRoute != null && sensorType != null) {
        final sensorConfig = configs.firstWhere(
          (config) => config.name == sensorConfigName,
          orElse: () => SensorConfig(
            name: 'Unknown',
            extremMin: 0.0,
            yellowLower: 0.0,
            normalMin: 0.0,
            normalMax: 0.0,
            yellowUpper: 0.0,
            extremMax: 0.0,
          ),
        );

        
        final sensorValue = double.tryParse(latestValue) ?? -1;
        final timestamp = DateTime.now().toIso8601String();
        final status = sensorConfigManager.checkSensorStatus(sensorConfig, sensorValue);

        manager.manageNotification(
          sensorName: measurement,
          status: status,
          message: "The sensor $measurement with the measure $sensorValue lies in the region of $status!",
          timestamp: timestamp,
          route: sensorRoute,
          type: sensorType,
        );
      } else {
        print('Konfigurationsdaten fehlen für $measurement.');
      }
    }

    print('Startup-Überprüfung abgeschlossen. Alle relevanten Notifications wurden erstellt.');
}

/// Normalizes a timestamp string to a simplified ISO 8601 format.
///
/// This function parses a given timestamp string, converts it to UTC, and
/// formats it in ISO 8601 format without nanoseconds or the `Z` suffix.
///
/// **Parameters:**
/// - [timestamp]: A [String] representing the timestamp to be normalized.
///
/// **Returns:**
/// - A [String] containing the normalized timestamp in `YYYY-MM-DDTHH:mm:ss` format
///   if the input is successfully parsed.
/// - If parsing fails, the original timestamp string is returned as a fallback.
static String _normalizeTimestamp(String timestamp) {
  try {
    final DateTime parsedTime = DateTime.parse(timestamp);
    // Entferne das `Z`-Suffix und gebe das Datum in ISO-Format ohne Nanosekunden aus
    return parsedTime.toUtc().toIso8601String().split('.').first;
  } catch (e) {
    print('Fehler beim Parsen des Zeitstempels: $timestamp');
    return timestamp; // Fallback: gebe den ursprünglichen Zeitstempel zurück
  }
}

}