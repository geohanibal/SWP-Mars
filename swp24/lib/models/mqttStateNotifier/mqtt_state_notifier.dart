import 'package:flutter/material.dart';
/// Author: Giacomo Gargula
///
/// The `MqttConnectionStatus` class provides a simple model for managing 
/// and notifying changes to the MQTT connection status in the application. 
/// It extends `ChangeNotifier` to allow listeners (e.g., UI components) to react
/// to changes in the connection status.
class MqttConnectionStatus extends ChangeNotifier {
  /// The current status of the MQTT connection.
  /// Default value is `'Disconnected'`.
  String _status = 'Disconnected';

  /// Getter for the current connection status.
  ///
  /// Returns the current status as a string, e.g., `'Connected'` or `'Disconnected'`.
  String get status => _status;

  /// Updates the connection status to `'Connected'`.
  ///
  /// Notifies all listeners about the status change.
  void setConnected() {
    _status = 'Connected';
    notifyListeners();
  }

  /// Updates the connection status to `'Disconnected'`.
  ///
  /// Notifies all listeners about the status change.
  void setDisconnected() {
    _status = 'Disconnected';
    notifyListeners();
  }
}
