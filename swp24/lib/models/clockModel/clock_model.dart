import 'dart:async';
import 'package:flutter/material.dart';
/// Author: Sergi Koniashvili
///
/// The `ClockModel` class provides a real-time clock functionality in the application.
/// It extends `ChangeNotifier` to allow listeners (e.g., UI components) to react
/// to changes in the current time.
class ClockModel extends ChangeNotifier {
  /// Timer that periodically updates the current time.
  late Timer _timer;
  /// Stores the formatted current time as a string (e.g., "HH:mm:ss").
  String _currentTime = _getFormattedTime();

  /// Constructor initializes the clock and starts updating the time every second.
  ClockModel() {
    _startClock();
  }

  /// Getter for the current time.
  /// 
  /// Returns the current time as a formatted string.
  String get currentTime => _currentTime;

  /// Starts the periodic timer to update the time every second.
  /// 
  /// On each tick, the current time is updated, and all listeners are notified.
  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime = _getFormattedTime();
      notifyListeners(); // Benachrichtige alle Listener (UI), dass sich die Uhrzeit geändert hat
    });
  }

  /// Returns the current time formatted as "HH:mm:ss".
  /// 
  /// Uses the current system time and formats it to ensure two digits
  /// for hours, minutes, and seconds.
  static String _getFormattedTime() {
    final now = DateTime.now();
    return "${_padZero(now.hour)}:${_padZero(now.minute)}:${_padZero(now.second)}";
  }

  /// Pads a single-digit number with a leading zero.
  /// 
  /// For example, 7 becomes "07".
  static String _padZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// Disposes of the resources used by the clock.
  /// 
  /// Stops the timer when the clock is no longer needed to free up resources.
  @override
  void dispose() {
    _timer.cancel(); 
    super.dispose();
  }
}