import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart'; // Für eindeutige IDs
/// NotificationManager
/// Author: Faridoon Noori
/// This class manages notifications for sensor statuses in the application. 
/// It supports adding, updating, removing notifications, and tracking the last update time.
class NotificationManager extends ChangeNotifier {
  final List<Map<String, dynamic>> _notifications = [];
  final _uuid = Uuid(); // Unique ID generator
  DateTime? _lastUpdated;

  /// Getter for the list of notifications
  List<Map<String, dynamic>> get notifications => _notifications;
  /// Getter for the last updated time
  DateTime? get lastUpdated => _lastUpdated;
  
  /// Manages notifications for sensors based on their current status and data.
  ///
  /// This function dynamically adds, updates, or removes notifications depending on the
  /// sensor's status. It ensures that the user is informed about critical or warning statuses
  /// and updates the state when sensors return to normal conditions.
  ///
  /// **Parameters:**
  /// - [sensorName]: The name of the sensor associated with the notification.
  /// - [status]: The current status of the sensor (e.g., "Normal", "Warning", "Critical").
  /// - [message]: A descriptive message for the notification.
  /// - [timestamp]: The current timestamp indicating when the status was evaluated.
  /// - [route]: The navigation route associated with the sensor.
  /// - [type]: The type of sensor or notification (e.g., "Temperature", "Pressure").
  ///
  /// **Process:**
  /// 1. Checks if a notification already exists for the sensor with a "Warning" or "Critical" status.
  /// 2. Based on the sensor's current status:
  ///    - **If the status is not "Normal":**
  ///      - **Add Notification:** Adds a new notification if none exists for the sensor.
  ///      - **Update Notification Status:** Updates the status if it differs from the existing notification.
  ///      - **Update Notification Message:** Updates the message if the status remains unchanged.
  ///    - **If the status is "Normal":**
  ///      - Removes any existing "Warning" or "Critical" notifications for the sensor.
  ///      - Creates a "Normal" notification with details about when the sensor returned to normal.
  ///
  /// 3. Calls `notifyListeners()` to update dependent UI components.
  void manageNotification({
  required String sensorName,
  required String status,
  required String message,
  required String timestamp,
  required String route,
  required String type,
}) {
  // Check if a notification already exists for the sensor with Warning or Critical status
  final existingNotification = _notifications.firstWhere(
    (n) => n['sensorName'] == sensorName && 
           (n['status'] == 'Warning' || n['status'] == 'Critical'),
    orElse: () => {},
  );

  if (status != 'Normal') {
    // Add a new notification if it doesn't exist
    if (existingNotification.isEmpty) {
      addNotification(
        message,
        sensorName,
        status,
        timestamp,
        route,
        type,
      );
    } else if (existingNotification['status'] != status) { // Update the status if it has changed
      updateNotification(
        sensorName,
        status,
        message,
      );
    } else {
      // Update the message if the status remains the same
      updateNotificationText(
        sensorName,
        message,
      );
    }
  } else {
   // If the status is Normal, remove any existing Warning or Critical notifications
    final existingNormalNotification = _notifications.firstWhere(
      (n) => n['sensorName'] == sensorName && n['status'] != 'Normal',
      orElse: () => {},
    );

    if (existingNormalNotification.isNotEmpty) {
      final startTime = existingNormalNotification['startTime'];
      updateToNormal(
        "The sensor $sensorName returned to normal region. Not optimal between $startTime until $timestamp",
        sensorName,
        timestamp,
      );
    }
  }

  notifyListeners();
}



  /// Adds a new notification to the notification list and notifies listeners.
  ///
  /// This function creates a notification object with the provided details, assigns
  /// it a unique ID, and adds it to the list of notifications. It then triggers
  /// a listener notification to update any dependent UI or state.
  ///
  /// **Parameters:**
  /// - [text]: A descriptive message for the notification.
  /// - [sensorName]: The name of the sensor associated with the notification.
  /// - [status]: The current status of the sensor (e.g., "Normal", "Warning", "Critical").
  /// - [startTime]: The timestamp indicating when the event or condition started.
  /// - [route]: The route in the application where the sensor's details can be accessed.
  /// - [type]: The type of sensor or notification (e.g., "Temperature", "Pressure").
  /// - [endTime] *(optional)*: The timestamp indicating when the event or condition ended.
  ///
  /// **Process:**
  /// 1. Creates a `notification` object with the provided details, including:
  ///    - A unique identifier (`id`) generated using `_uuid.v4()`.
  ///    - All relevant fields, including optional `endTime` if provided.
  /// 2. Adds the created notification object to the `_notifications` list.
  /// 3. Calls `notifyListeners()` to inform listeners that the notification list has been updated.
  void addNotification(String text, String sensorName, String status, String startTime, String route, String type, [String? endTime]) {
    final notification = {
      'id': _uuid.v4(), // Eindeutige ID
      'text': text,
      'sensorName': sensorName,
      'status': status,
      'startTime': startTime,
      'endTime': endTime,
      'route': route,
      'type' : type,
    };
    _notifications.add(notification);
    notifyListeners();
  }
  /// Updates the status and text of an existing notification for a specific sensor.
  ///
  /// This function locates an active notification for the given sensor with a status of
  /// either "Warning" or "Critical" and updates its status and message if found.
  ///
  /// **Parameters:**
  /// - [sensorName]: The name of the sensor whose notification needs updating.
  /// - [newStatus]: The new status to assign to the notification (e.g., "Warning", "Critical").
  /// - [text]: The new message to display in the notification.
  ///
  /// **Process:**
  /// 1. Searches for an existing notification for the given sensor with a "Warning" or "Critical" status.
  /// 2. If a matching notification is found:
  ///    - Updates its `status` field with the new status.
  ///    - Updates its `text` field with the new message.
  /// 3. Calls `notifyListeners()` to reflect the changes in the UI.
  void updateNotification(String sensorName, String newStatus, String text) {
    final notification = _notifications.firstWhere(
      (n) => n['sensorName'] == sensorName && (n['status'] == 'Warning' || n['status'] == 'Critical'),
      orElse: () => {},
    );
    if (notification.isNotEmpty) {
      notification['status'] = newStatus;
      notification['text'] = text;
      notifyListeners();
    }
  }
  /// Updates an existing notification to indicate that a sensor has returned to normal status.
  ///
  /// This function finds a notification for a specific sensor with a non-"Normal" status
  /// and updates it to reflect the "Normal" status with an associated end time and message.
  ///
  /// **Parameters:**
  /// - [text]: The descriptive message indicating that the sensor has returned to normal.
  /// - [sensorName]: The name of the sensor associated with the notification.
  /// - [endTime]: The timestamp indicating when the sensor returned to normal.
  ///
  /// **Process:**
  /// 1. Searches for an existing notification for the given sensor with a non-"Normal" status.
  /// 2. If a matching notification is found:
  ///    - Updates its `text` field with the provided message.
  ///    - Sets its `status` to "Normal".
  ///    - Assigns the `endTime` to indicate when the sensor returned to normal.
  /// 3. Calls `notifyListeners()` to update the state.
  void updateToNormal(String text, String sensorName, String endTime) {
    final notification = _notifications.firstWhere(
      (n) => n['sensorName'] == sensorName && n['status'] != 'Normal',
      orElse: () => {},
    );
    if (notification.isNotEmpty) {
      notification['text'] = text;
      notification['status'] = 'Normal';
      notification['endTime'] = endTime;
      notifyListeners();
    }
  }
/// Updates the message text of an existing notification for a specific sensor.
///
/// This function locates an active notification for the given sensor with a status of
/// either "Warning" or "Critical" and updates its message text.
///
/// **Parameters:**
/// - [sensorName]: The name of the sensor whose notification text needs updating.
/// - [text]: The new message text to display in the notification.
///
/// **Process:**
/// 1. Searches for an existing notification for the given sensor with a "Warning" or "Critical" status.
/// 2. If a matching notification is found:
///    - Updates its `text` field with the provided message.
/// 3. Calls `notifyListeners()` to propagate the change.
 void updateNotificationText(String sensorName, String text) {
  final notification = _notifications.firstWhere(
    (n) => n['sensorName'] == sensorName &&
           (n['status'] == 'Warning' || n['status'] == 'Critical'),
    orElse: () => {},
  );

  if (notification.isNotEmpty) {
    notification['text'] = text;
    notifyListeners();
  }
}
  /// Removes a notification from the list based on its unique identifier.
  ///
  /// This function locates a notification with the specified `id` and removes it from
  /// the notification list. It triggers an update to refresh any dependent UI.
  ///
  /// **Parameters:**
  /// - [id]: The unique identifier of the notification to be removed.
  ///
  /// **Process:**
  /// 1. Searches for a notification in the `_notifications` list with the matching `id`.
  /// 2. Removes the matching notification from the list.
  /// 3. Calls `notifyListeners()` to update the state.
  void removeNotification(String id) {
    _notifications.removeWhere((n) => n['id'] == id);
    notifyListeners();
  }

  /// Updates the `lastUpdated` timestamp to the current time.
  ///
  /// This function sets the `_lastUpdated` variable to the current timestamp and
  /// triggers a listener notification to update any UI components displaying this value.
  ///
  /// **Parameters:**
  /// - None.
  ///
  /// **Process:**
  /// 1. Sets `_lastUpdated` to the current time using `DateTime.now()`.
  /// 2. Calls `notifyListeners()` to reflect the change in the UI.
   void updateLastUpdated() {
    _lastUpdated = DateTime.now();
    notifyListeners();
  }
}