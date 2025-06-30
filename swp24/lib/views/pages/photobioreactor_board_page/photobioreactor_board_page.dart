import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/navigation/navigation_logic.dart';
import '../../../models/mqttStateNotifier/mqtt_state_notifier.dart';
import '../../../models/clockModel/clock_model.dart';
import '../../../services/sensor_config_manager/sensor_config_manager.dart';
import '../../../models/sensorConfigModel/sensor_config.dart';
import '../../widgets/home_page/bottom_nav_bar.dart';
import '../../../services/notification_manager/norification_manager.dart';
/// A stateless eidget that represents the Main Photobioreactorpage.
/// 
/// This page displays the two navigationoption to nutrient medium and gas outlet.
/// It also includes navigation, status, and notifications management.
class PhotobioreactorBoardPage extends StatefulWidget {

  const PhotobioreactorBoardPage({Key? key}) : super(key: key);

  @override
  State<PhotobioreactorBoardPage> createState() => _PhotobioreactorBoardPage();
}

class _PhotobioreactorBoardPage extends State<PhotobioreactorBoardPage> {
  @override
  Widget build(BuildContext context) {
    final mqttStatus = context.watch<MqttConnectionStatus>().status;
    final currentTime = context.watch<ClockModel>().currentTime;

    return Scaffold(
      body: Row(
        children: [
          // vertical navigation (left)
          Container(
            width: 80,
            color: Colors.grey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNavItem(context, route: '/', icon: Icons.home, label: 'Dashboard'),
                _buildNavItem(context, route: '/sensorboard', icon: Icons.sensors, label: 'Sensorboard'),
                _buildNavItem(context, route: '/photobioreactor', icon: Icons.biotech, label: 'Photobioreactor'),
                const Divider(color: Colors.white),
                _buildNavItem(context, route: '/photobioreactor/nutrient_medium', icon: Icons.science, label: 'Nutrient Medium'),
                _buildNavItem(context, route: '/photobioreactor/gas_outlet', icon: Icons.gas_meter, label: 'Gas Outlet'),
                const Divider(color: Colors.white),
                _buildNavItem(context, route: '/chat', icon: Icons.chat, label: 'Chat'),
              ],
            ),
          ),

          // middle part
          Expanded(
            child: Container(
              color: Colors.grey[800],
              child: FutureBuilder<List<SensorConfig>>(
                future: SensorConfigManager().loadConfigs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final configs = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titel
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Photobioreactor',
                          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(color: Colors.white, thickness: 1),
                      //Sensor selection   
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          padding: const EdgeInsets.all(10),
                          childAspectRatio: 2,
                          children: [
                            _buildSensorBox(context, 'Nutrient Medium', '/photobioreactor/nutrient_medium'),
                            _buildSensorBox(context, 'Gas Outlet', '/photobioreactor/gas_outlet'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Right Status and Notifications Column
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
                          const Text('Sensorstatus:', style: TextStyle(fontSize: 16)),
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
                          const Text('Phobioreactorstatus:', style: TextStyle(fontSize: 16)),
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
                        print("avaible notifications: $notifications");

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
/// Builds a styled, clickable sensor box widget.
///
/// This widget represents a box with a title, which navigates to a specific
/// route when tapped. It is styled with a blue background and rounded corners.
/// Returns a [GestureDetector], that forms a clickable box.
///
/// - [context]: The current [BuildContext].
/// - [title]: The text displayed at the center of the box.
/// - [route]: The navigation route triggered upon tapping the box.
///
  Widget _buildSensorBox(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () => NavigationLogic.navigateTo(context, route),
      child: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
  /// Returns the status color based on the notification status.
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
  // Filtere die Notifications für den gegebenen Typ
  final filteredNotifications = notifications.where((n) => n['type'] == type).toList();

  if (filteredNotifications.any((n) => n['status'] == 'Critical')) {
    // Wenn es mindestens eine kritische Notification gibt
    return Colors.red;
  } else if (filteredNotifications.any((n) => n['status'] == 'Warning')) {
    // Wenn es nur Warnungen gibt
    return Colors.yellow;
  } else {
    // Wenn es keine relevanten Notifications gibt
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
  /// on whether the current route matches the item's route. Returns a [Tooltip], as a navigation component
  Widget _buildNavItem(
    BuildContext context, {
    required String route,
    required IconData icon,
    required String label,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isActive = currentRoute == route;

    return Tooltip(
      message: label,
      child: Container(
        color: isActive ? Colors.blue : Colors.transparent,
        child: IconButton(
          icon: Icon(icon, color: isActive ? Colors.white : Colors.grey[500]),
          onPressed: () {
            NavigationLogic.navigateTo(context, route);
          },
        ),
      ),
    );
  }
}
