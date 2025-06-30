import 'dart:io'; // SocketException-ისთვის
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
//import '../notification_logic/notification_manager.dart';
//import '../../models/notificationModel/notification_message.dart';
import '../data_manager/data_manager.dart';
import '../../models/measurementMatcher/measurement_matcher.dart';
import '../../models/mqttStateNotifier/mqtt_state_notifier.dart';
import '../../services/sensor_config_manager/sensor_config_manager.dart';
import '../../models/sensorConfigModel/sensor_config.dart';
import '../notification_manager/norification_manager.dart';
import '../../models/sensorConfigMatcher/sensor_config_matcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/navigationMatcher/navigation_matcher.dart';
import '../../models/StatusMatcher/status_matcher.dart';

/// MQTT Client Setup
/// Author: Giacomo Gargula
/// This file initializes communication with the MQTT broker, subscribes to the relevant topics, 
/// and processes incoming sensor data. The data is stored in the global data list (managed by DataManager).
final client = MqttServerClient.withPort('127.0.0.1', 'flutter_client', 1883) //127.0.0.1 = Localhost
  ..logging(on: true)
  ..setProtocolV311() // Uses the updated MQTT protocol version
  ..keepAlivePeriod = 20
  ..secure = false;

/// Sets up and initializes the MQTT client connection.
///
/// This function configures the MQTT client by defining callbacks for connection,
/// disconnection, and the receipt of ping responses. It then attempts to establish
/// a connection to the MQTT broker, and if successful, subscribes to predefined topics.
///
/// **Parameters:**
/// - [mqttConnectionStatus]: An instance of [MqttConnectionStatus], used to track
///   and manage the connection status of the MQTT client.
void setupMqttClient(MqttConnectionStatus mqttConnectionStatus) async {
  client.onConnected = () => onConnected(mqttConnectionStatus);
  client.onDisconnected = () => onDisconnected(mqttConnectionStatus);
  client.pongCallback = pong;
  
   try {
    print('Attempting to connect to MQTT Broker...');
    await client.connect(); 

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT connected successfully');
      mqttConnectionStatus.setConnected();
      subscribeToTopics(); 
    } else {
      print('MQTT connection failed: Status = ${client.connectionStatus?.state}');
      mqttConnectionStatus.setDisconnected();
    }
  } on NoConnectionException catch (e) {
    print('MQTT connection failed (NoConnectionException): $e');
    mqttConnectionStatus.setDisconnected();
  } on SocketException catch (e) {
    print('Socket error during MQTT connection: $e');
    mqttConnectionStatus.setDisconnected();
  } catch (e) {
    print('Unexpected error during MQTT connection: $e');
    mqttConnectionStatus.setDisconnected();
  }
}
/// Subscribes to a predefined list of MQTT topics of swp conditions
void subscribeToTopics() {
  final topics = [
    "board1/temp1_am",
    "board1/temp2_am",
    "board1/temp3_am",
    "board1/temp4_am",
    "board2/temp1_am",
    "board2/temp2_am",
    "board2/temp3_am",
    "board2/temp4_am",
    "board3/temp1_am",
    "board3/temp2_am",
    "board3/temp3_am",
    "board3/temp4_am",
    "board4/temp1_am",
    "board4/temp2_am",
    "board4/temp3_am",
    "board4/temp4_am",
    "board1/amb_press",
    "board2/amb_press",
    "board3/amb_press",
    "board4/amb_press",
    "board1/o2",
    "board2/o2",
    "board3/o2",
    "board4/o2",
    "board1/co2",
    "board2/co2",
    "board3/co2",
    "board4/co2",
    "board1/co",
    "board2/co",
    "board3/co",
    "board4/co",
    "board1/o3",
    "board2/o3",
    "board3/o3",
    "board4/o3",
    "board1/humid1_am",
    "board1/humid2_am",
    "board1/humid3_am",
    "board1/humid4_am",
    "board2/humid1_am",
    "board2/humid2_am",
    "board2/humid3_am",
    "board2/humid4_am",
    "board3/humid1_am",
    "board3/humid2_am",
    "board3/humid3_am",
    "board3/humid4_am",
    "board4/humid1_am",
    "board4/humid2_am",
    "board4/humid3_am",
    "board4/humid4_am",
    "pbr1/temp_1",
    "pbr1/temp_g_2",
    "pbr1/amb_press_2",
    "pbr1/do",
    "pbr1/o2_2",
    "pbr1/co2_2",
    "pbr1/rh_2",
    "pbr1/ph",
    "pbr1/od",
  ];

  for (var topic in topics) {
    client.subscribe(topic, MqttQos.atMostOnce);
    print('Subscribed to topic: $topic');
  }
}

/// Callback when the MQTT client successfully connects to the broker
void onConnected(MqttConnectionStatus mqttConnectionStatus) {
  mqttConnectionStatus.setConnected();
  print('Successfully connected to MQTT Broker.');
}

/// Callback when the MQTT client disconnects from the broker
void onDisconnected(MqttConnectionStatus mqttConnectionStatus) {
  mqttConnectionStatus.setDisconnected();
  print('Disconnected from MQTT Broker.');
}

/// Callback for handling the MQTT "ping" response
void pong() {
  print('Ping response received from MQTT Broker.');
}

// Send messages to a topic
void sendMessage(String topic, String message) {
  final builder = MqttClientPayloadBuilder();
  builder.addString(message);
  client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  print('Message sent to topic $topic: $message');
}

/// Example function to listen to chat messages from MQTT topics
void listenToChatMessages() {
  client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
    final recMessage = events[0].payload as MqttPublishMessage;
    final payload =
        MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
    print('Message received on topic: ${events[0].topic}, Message: $payload');
  });
}

/// Listens to real-time sensor updates via the MQTT client and processes them.
///
/// This function subscribes to the MQTT client's message updates and handles
/// incoming sensor data. It updates the application's state, manages notifications,
/// and stores the new sensor data for further use.
///
/// **Parameters:**
/// - [context]: The current [BuildContext], used to access the [NotificationManager].
///
/// **Process:**
/// 1. Loads sensor configurations using the `SensorConfigManager`.
/// 2. Listens for real-time updates from the MQTT client (`client.updates`).
/// 3. For each received message:
///    - Extracts the payload from the MQTT message and parses it as a string.
///    - Maps the MQTT topic to its corresponding database name using `MeasurementMatcher`.
///    - Checks if the database name, sensor configuration, route, and type exist.
///      If any are missing, logs an error and skips further processing.
///    - Retrieves the sensor's configuration and parses the sensor value.
///    - Updates the timestamp to the current UTC time in ISO 8601 format.
///    - Updates the `NotificationManager`'s last updated time.
///    - Stores the new sensor data in the `DataManager`.
///    - Determines the sensor's status based on its configuration and the parsed value.
///    - Creates or updates a notification with details about the sensor's current state.
void listenToSensorUpdates(BuildContext context) async {
  final manager = Provider.of<NotificationManager>(context, listen: false);
  final configs = await SensorConfigManager().loadConfigs();
  final sensorConfigManager = SensorConfigManager();

  client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
    for (var message in events) {
      final recMessage = message.payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      final sensorDBName = MeasurementMatcher.getDatabaseName(message.topic);
    
      if (sensorDBName !=null){
      final sensorConfigName = SensorConfigMatcher.getSensorConfigName(sensorDBName);
      final sensorRoute = NavigationMatcher.getRoute(sensorDBName);
      final sensorType = StatusMatcher.getSensorStatusType(sensorDBName);

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

        final sensorValue = double.tryParse(payload) ?? -1;
        final timestamp = DateTime.now().toIso8601String();

        manager.updateLastUpdated();

        // Speichere die neuen Daten
        DataManager().addData(sensorDBName, [
          {'time': timestamp, 'value': sensorValue},
        ]);

        final status = sensorConfigManager.checkSensorStatus(sensorConfig, sensorValue);

        // Verwende die neue Methode zur Verwaltung der Notifications
        manager.manageNotification(
          sensorName: sensorDBName,
          status: status,
          message: "The sensor $sensorDBName with the measure $sensorValue lies in the region of $status!",
          timestamp: timestamp,
          route: sensorRoute,
          type: sensorType,
        );

        print('Daten wurden in $sensorDBName gespeichert: $sensorValue');
        print('Notificationlist: ${manager.notifications}');
      } else {
        print('Kein Datenbankname für Topic: ${message.topic}');
      }
      }else {
        print('Kein Datenbankname für Topic: ${message.topic}');
      }
    }
  });
}
