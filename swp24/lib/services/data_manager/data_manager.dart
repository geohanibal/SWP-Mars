import 'package:flutter/foundation.dart';

/// Author: Giacomo Gargula
///
/// The `DataManager` class serves as a central data manager for the project.
/// It is implemented as a Singleton, ensuring only one instance of the class
/// exists throughout the application. This prevents parallel instances and provides
/// consistent access to stored data.
///
/// The class maintains a global map of received data, where:
/// - Keys represent specific MQTT topics.
/// - Values are lists of maps containing the data associated with those topics.
///
/// Key functionalities of the `DataManager` include:
/// - Adding data for a specific topic using [addData].
/// - Retrieving stored data for a specific topic using [getData].
/// - Fetching the latest value for a topic using [getLatestValue].
/// - Sorting data by timestamp during initialization using [sortInitialData].
/// 
/// The class extends `ChangeNotifier`, enabling the app's UI components to 
/// listen for data changes and react accordingly.
class DataManager extends ChangeNotifier {
  /// Singleton instance of `DataManager`.
  static final DataManager _instance = DataManager._internal();

  /// Factory constructor returning the Singleton instance.
  factory DataManager() => _instance;

   /// Private internal constructor for the Singleton pattern.
  DataManager._internal();

  /// The global map that stores data for all topics.
  /// 
  /// Keys: Strings representing MQTT topics.
  /// Values: Lists of maps containing data, each with properties like `value` and `time`.
  final Map<String, List<Map<String, dynamic>>> _globalData = {};

  /// Getter for accessing the global data map.
  Map<String, List<Map<String, dynamic>>> get globalData => _globalData;

  /// Adds data for a specific topic.
  ///
  /// - [key]: The topic name as a string.
  /// - [data]: A list of maps containing data to be added.
  ///
  /// If the topic already exists in `_globalData`, the new data is appended.
  /// Otherwise, the topic is initialized with the provided data.
  /// 
  /// Notifies all listeners about the update.
  void addData(String key, List<Map<String, dynamic>> data) {
    if (_globalData.containsKey(key)) {
      // Füge die neuen Daten hinzu und stelle sicher, dass sie am Ende bleiben
      _globalData[key]!.addAll(data);
    } else {
      // Neue Daten initialisieren
      _globalData[key] = data;
    }

  notifyListeners(); // Notify all listeners about the data update.
}

/// Retrieves the latest value for a specific topic.
///
/// - [key]: The topic name as a string.
/// - Returns: The latest value as a string if data exists, or `'N/A'` if not.
String getLatestValue(String key) {
  final data = _globalData[key];
  if (data != null && data.isNotEmpty) {
    return data.last['value'].toString(); // Der erste Wert ist der aktuellste
  }
  return 'N/A';
}



  /// Retrieves data for a specific topic.
  ///
  /// - [key]: The topic name as a string.
  /// - Returns: A list of maps containing the topic's data, or `null` if the topic doesn't exist.
  List<Map<String, dynamic>>? getData(String key) => _globalData[key];

  /// Sorts the data for all topics by their timestamp.
  ///
  /// This method should be called during app initialization to ensure all
  /// data is correctly ordered.
  void sortInitialData() {
    for (String key in _globalData.keys) {
      _globalData[key]!.sort((a, b) =>
          DateTime.parse(a['time']).compareTo(DateTime.parse(b['time'])));
    }
  }
}