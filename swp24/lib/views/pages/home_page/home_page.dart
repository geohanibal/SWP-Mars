import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/home_page/bottom_nav_bar.dart';
import '../../../controllers/navigation/navigation_logic.dart';
import '../../../models/mqttStateNotifier/mqtt_state_notifier.dart';
import '../../../models/clockModel/clock_model.dart';
import '../../../services/notification_manager/norification_manager.dart';

/// HomePage is a stateful widget that serves as the main dashboard for the application.
/// It includes navigation, a central display area, and a status/notification panel.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Retrieve MQTT status and the current time using Provider.
    final mqttStatus = context.watch<MqttConnectionStatus>().status;
    final currentTime = context.watch<ClockModel>().currentTime;

    return Scaffold(
      body: Row(
        children: [
          // Left Navigation
          Container(
            width: 80,
            color: Colors.grey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNavItem(
                  context,
                  route: '/',
                  icon: Icons.home,
                  label: 'Dashboard',
                ),
                _buildNavItem(
                  context,
                  route: '/sensorboard',
                  icon: Icons.sensors,
                  label: 'Sensorboard',
                ),
                _buildNavItem(context, route: '/photobioreactor', icon: Icons.biotech, label: 'Photobioreactor'),
                _buildNavItem(
                  context,
                  route: '/chat',
                  icon: Icons.chat,
                  label: 'Chat',
                ),
              ],
            ),
          ),

          // Main Content Area (Middle Section)
          Expanded(
            child: Container(
              color: Colors.grey[800],
              child: Center(
                child: Image.asset(
                  'assets/images/Viertelansicht_habitat_screenshot.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Right Column (Status and Notifications)
          Container(
            width: 300,
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Status',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time: $currentTime', style: const TextStyle(fontSize: 16)),
                      Text('MQTT: $mqttStatus', style: const TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          const Text('Sensor Status:', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Consumer<NotificationManager>(
                            builder: (context, notificationManager, _) {
                              final sensorStatus = _determineStatus(notificationManager.notifications, 'Sensor');
                              return Icon(
                                Icons.circle,
                                color: sensorStatus,
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Photobioreactor Status:', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Consumer<NotificationManager>(
                            builder: (context, notificationManager, _) {
                              final photobioreactorStatus = _determineStatus(notificationManager.notifications, 'Photobioreactor');
                              return Icon(
                                Icons.circle,
                                color: photobioreactorStatus,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Notifications Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Consumer<NotificationManager>(
                      builder: (context, notificationManager, _) {
                        final notifications = notificationManager.notifications;

                        if (notifications.isEmpty) {
                          return const Center(
                            child: Text(
                              'No notifications',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];

                            return GestureDetector(
                              onTap: () {
                                final route = notification['route'];
                                if (route != null) {
                                  NavigationLogic.navigateTo(context, route);
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(notification['status']),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification['text'] ?? 'No message',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (notification['status'] == 'Normal')
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Color.fromARGB(255, 0, 0, 0)),
                                        onPressed: () {
                                          notificationManager.removeNotification(notification['id']);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Last Updated Section
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Last Updated',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<NotificationManager>(
                      builder: (context, notificationManager, _) {
                        final lastUpdated = notificationManager.lastUpdated;
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            lastUpdated != null
                                ? 'Last Update: ${lastUpdated.toLocal()}'
                                : 'No updates yet',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  /// Returns the color associated with a given notification status.
  ///
  /// - `status`: A string representing the notification status.
  ///
  /// Returns:
  /// - [Colors.red] for "Critical"
  /// - [Colors.yellow] for "Warning"
  /// - [Colors.green] for "Normal"
  /// - [Colors.grey] for any other status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Critical':
        return Colors.red;
      case 'Warning':
        return Colors.yellow;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Determines the color of the status icon based on notifications of a specific type.
  ///
  /// - `notifications`: A list of notifications as maps.
  /// - `type`: The type of notification to filter by.
  ///
  /// Returns:
  /// - [Colors.red] if any notification of the specified type has a status of "Critical".
  /// - [Colors.yellow] if any notification of the specified type has a status of "Warning".
  /// - [Colors.green] if all notifications of the specified type have a status of "Normal".
  Color _determineStatus(List<Map<String, dynamic>> notifications, String type) {
    // Filter notifications for the specified type.
    final filteredNotifications = notifications.where((n) => n['type'] == type).toList();

    if (filteredNotifications.any((n) => n['status'] == 'Critical')) {
      return Colors.red;
    } else if (filteredNotifications.any((n) => n['status'] == 'Warning')) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  /// Builds a navigation item for the left navigation panel.
  ///
  /// - `context`: The current [BuildContext].
  /// - `route`: The navigation route for the item.
  /// - `icon`: The icon to display for the item.
  /// - `label`: The tooltip text for the item.
  ///
  /// This method creates a clickable navigation item that changes appearance based
  /// on whether the current route matches the item's route.
  Widget _buildNavItem(
    BuildContext context, {
    required String route,
    required IconData icon,
    required String label,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name; // Current route
    final isActive = currentRoute == route; // Check if the route is active

    return Tooltip(
      message: label,
      child: Container(
        color: isActive ? Colors.blue : Colors.transparent, // Active color
        child: IconButton(
          icon: Icon(icon, color: isActive ? Colors.white : Colors.grey[500]),
          onPressed: () {
            if (!isActive) {
              NavigationLogic.navigateTo(context, route);
            }
          },
        ),
      ),
    );
  }
}
