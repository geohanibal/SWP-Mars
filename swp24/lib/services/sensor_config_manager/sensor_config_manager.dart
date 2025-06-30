import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/sensorConfigModel/sensor_config.dart';

/// SensorConfigManager
/// Author: Sergi Koniashvili
/// This class manages the configuration settings for sensors. It provides methods 
/// to load, save, and check the status of sensor configurations.
class SensorConfigManager {
  static const _storageKey = 'sensor_configs'; // Key for storing sensor configurations in SharedPreferences

  /// Loads sensor configurations from local storage (SharedPreferences).
  /// If no configurations are found, it returns a list of default configurations.
  Future<List<SensorConfig>> loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getString(_storageKey);

    if (configsJson != null) {
      // Parse JSON to a list of SensorConfig objects
      final List<dynamic> jsonList = jsonDecode(configsJson);
      return jsonList.map((json) => SensorConfig.fromJson(json)).toList();
    }

    // Default Configs
   return [
      SensorConfig(
          name: 'Temperature',
          extremMin: 18.0,
          yellowLower: 18.0,
          normalMin: 25.0,
          normalMax: 32.0,
          yellowUpper: 35.0,
          extremMax: 36.0),
      SensorConfig(
          name: 'Air Pressure',
          extremMin: 900.0,
          yellowLower: 920.0,
          normalMin: 950.0,
          normalMax: 1040.0,
          yellowUpper: 1080.0,
          extremMax: 1100.0),
      SensorConfig(
          name: 'O2 Concentration',
          extremMin: 0.0,
          yellowLower: 18.0,
          normalMin: 21.0,
          normalMax: 23.0,
          yellowUpper: 25.0,
          extremMax: 35.0),
      SensorConfig(
          name: 'CO2 Concentration',
          extremMin: 0.0,
          yellowLower: 0.0,
          normalMin: 300.0,
          normalMax: 2900.0,
          yellowUpper: 3000.0,
          extremMax: 4000.0),
      SensorConfig(
          name: 'CO Concentration',
          extremMin: 0.0,
          yellowLower: 0.0,
          normalMin: 0.0,
          normalMax: 5.0,
          yellowUpper: 25.0,
          extremMax: 30.0),
      SensorConfig(
          name: 'O3 Concentration',
          extremMin: 0.0,
          yellowLower: 0.0,
          normalMin: 0.0,
          normalMax: 100.0,
          yellowUpper: 150.0,
          extremMax: 200.0),
      SensorConfig(
          name: 'Humidity',
          extremMin: 0.0,
          yellowLower: 0.0,
          normalMin: 40.0,
          normalMax: 95.0,
          yellowUpper: 100.0,
          extremMax: 100.0),
      SensorConfig(
          name: 'Temperature (Reactor, l)',
          extremMin: 18.0,
          yellowLower: 18.0,
          normalMin: 25.0,
          normalMax: 32.0,
          yellowUpper: 35.0,
          extremMax: 36.0),
      SensorConfig(
          name: 'Temperature (Output, g)',
          extremMin: 18.0,
          yellowLower: 18.0,
          normalMin: 25.0,
          normalMax: 32.0,
          yellowUpper: 35.0,
          extremMax: 36.0),
      SensorConfig(
          name: 'Air Pressure (Output, g)',
          extremMin: 900.0,
          yellowLower: 920.0,
          normalMin: 950.0,
          normalMax: 1040.0,
          yellowUpper: 1080.0,
          extremMax: 1100.0),
      SensorConfig(
          name: 'Dissolved O2 (PBR, l)',
          extremMin: 0.0,
          yellowLower: 3.0,
          normalMin: 5.0,
          normalMax: 15.0,
          yellowUpper: 16.0,
          extremMax: 20.0),
      SensorConfig(
          name: 'O2 Concentration (Output, g)',
          extremMin: 0.0,
          yellowLower: 18.0,
          normalMin: 21.0,
          normalMax: 35.0,
          yellowUpper: 35.0,
          extremMax: 35.0),
      SensorConfig(
          name: 'CO2 Concentration (Output, g)',
          extremMin: 0.0,
          yellowLower: 0.0,
          normalMin: 0.0,
          normalMax: 400.0,
          yellowUpper: 1000.0,
          extremMax: 3000.0),
      SensorConfig(
          name: 'Humidity (Output, g)',
          extremMin: 0.0,
          yellowLower: 18.0,
          normalMin: 21.0,
          normalMax: 35.0,
          yellowUpper: 35.0,
          extremMax: 35.0),
      SensorConfig(
          name: 'pH Value (PBR, l)',
          extremMin: 0.0,
          yellowLower: 5.0,
          normalMin: 6.0,
          normalMax: 11.0,
          yellowUpper: 12.0,
          extremMax: 14.0),
      SensorConfig(
          name: 'Optical Density (PBR, l)',
          extremMin: 0.0,
          yellowLower: 0.0,
          normalMin: 0.1,
          normalMax: 0.9,
          yellowUpper: 1.0,
          extremMax: 1.0),
    ];
  }

  /// Saves the list of sensor configurations to persistent storage.
  ///
  /// This function serializes a list of [SensorConfig] objects into JSON format and
  /// stores it using the `SharedPreferences` API for later retrieval.
  ///
  /// **Parameters:**
  /// - [configs]: A list of [SensorConfig] objects to be saved.
  ///
  /// **Process:**
  /// 1. Retrieves an instance of `SharedPreferences`.
  /// 2. Converts the list of [SensorConfig] objects into a JSON string using `toJson`.
  /// 3. Saves the JSON string to persistent storage under a predefined storage key.
  Future<void> saveConfigs(List<SensorConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = jsonEncode(configs.map((config) => config.toJson()).toList());
    await prefs.setString(_storageKey, configsJson);
  }

  /// Determines the status of a sensor based on its configuration and current value.
  ///
  /// This function evaluates a sensor's value against its configured thresholds
  /// to determine whether its status is "Normal", "Warning", or "Critical".
  ///
  /// **Parameters:**
  /// - [config]: The [SensorConfig] object containing the sensor's thresholds.
  /// - [value]: The current value of the sensor.
  ///
  /// **Returns:**
  /// - A [String] representing the sensor's status:
  ///   - `"Normal"`: If the value falls within the normal range (`normalMin` to `normalMax`).
  ///   - `"Warning"`: If the value falls within the warning range (`yellowLower` to `normalMin` or `normalMax` to `yellowUpper`).
  ///   - `"Critical"`: If the value falls outside both the normal and warning ranges.
  ///
  /// **Process:**
  /// 1. Checks if the value is within the normal range (`normalMin < value < normalMax`).
  ///    - Returns "Normal" if true.
  /// 2. Checks if the value falls within the warning range:
  ///    - Between `normalMax` and `yellowUpper`, or
  ///    - Between `yellowLower` and `normalMin`.
  ///    - Returns "Warning" if true.
  /// 3. Returns "Critical" if the value does not meet the above conditions.
  String checkSensorStatus(SensorConfig config, double value) {
    if (config.normalMin < value && value < config.normalMax) {
      return 'Normal';
    }
    if (config.normalMax <= value && value < config.yellowUpper
        || config.yellowLower < value && value <= config.normalMin) {
          return 'Warning';
        }
    return 'Critical';
  }
}
