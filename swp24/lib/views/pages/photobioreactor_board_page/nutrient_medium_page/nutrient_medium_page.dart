import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/navigation/navigation_logic.dart';
import '../../../../models/mqttStateNotifier/mqtt_state_notifier.dart';
import '../../../../models/clockModel/clock_model.dart';
import '../../../../services/data_manager/data_manager.dart';
import '../../../../services/sensor_config_manager/sensor_config_manager.dart';
import '../../../../models/sensorConfigModel/sensor_config.dart';
import '../../../widgets/home_page/bottom_nav_bar.dart';
import '../../../../services/notification_manager/norification_manager.dart';

/// A stateless eidget that represents the Nutrient Medium Page.
/// 
/// This page displays sensor data for managing the nutrient medium in a photobioreactor,
/// such as temperature, dissolved oxygen, pH levels, and optical density.
/// It also includes navigation, status, and notifications management.
class NutrientMediumPage extends StatelessWidget {
  const NutrientMediumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mqttStatus = context.watch<MqttConnectionStatus>().status;
    final currentTime = context.watch<ClockModel>().currentTime;

    return Scaffold(
      body: Row(
        children: [
          // Left Navigation Panel
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
                const Divider(color: Colors.white),
                _buildNavItem(context, route: '/photobioreactor/nutrient_medium', icon: Icons.science, label: 'Nutrient Medium'),
                _buildNavItem(context, route: '/photobioreactor/gas_outlet', icon: Icons.gas_meter, label: 'Gas Outlet'),
                const Divider(color: Colors.white),
                _buildNavItem(
                  context,
                  route: '/chat',
                  icon: Icons.chat,
                  label: 'Chat',
                ),
              ],
            ),
          ),

          // Middle Section
         Expanded(
  child: Container(
    color: Colors.grey[800],
    padding: const EdgeInsets.all(16.0),
    child: FutureBuilder<List<SensorConfig>>(
      future: SensorConfigManager().loadConfigs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final configs = snapshot.data!;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Nutrient Medium',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sensor Values
                  Consumer<DataManager>(
                    builder: (context, manager, _) {
                      String formatValue(double value) =>
                          value.toStringAsFixed(3);

                      Color determineColor(
                          String sensorName, double value) {
                        final config = configs.firstWhere(
                            (c) => c.name == sensorName,
                            orElse: () => SensorConfig(
                                name: 'Unknown',
                                extremMin: 0.0,
                                yellowLower: 0.0,
                                normalMin: 0.0,
                                normalMax: 0.0,
                                yellowUpper: 0.0,
                                extremMax: 0.0));

                        if (config.normalMin < value && value < config.normalMax) {
                          return Colors.green; // 'Normal'
                        }
                        if ((config.normalMax <= value && value < config.yellowUpper) ||
                            (config.yellowLower < value && value <= config.normalMin)) {
                          return Colors.yellow; // 'Warning'
                        }
                        return Colors.red; // 'Critical'
                      }

                      final temp1 =
                          double.tryParse(manager.getLatestValue('pbr1_temp_l')) ??
                              0.0;
                      final temp2 =
                          double.tryParse(manager.getLatestValue('pbr1_do')) ??
                              0.0;
                      final temp3 =
                          double.tryParse(manager.getLatestValue('pbr1_ph')) ??
                              0.0;
                      final temp4 =
                          double.tryParse(manager.getLatestValue('pbr1_od')) ??
                              0.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildField(
                            'Temperature',
                            formatValue(temp1),
                            determineColor('Temperature (Reactor, l)', temp1),
                          ),
                          _buildField(
                            'Dissolved O2',
                            formatValue(temp2),
                            determineColor('Dissolved O2 (PBR, l)', temp2),
                          ),
                          _buildField(
                            'pH Value',
                            formatValue(temp3),
                            determineColor('pH Value (PBR, l)', temp3),
                          ),
                          _buildField(
                            'Optical Density',
                            formatValue(temp4),
                            determineColor('Optical Density (PBR, l)', temp4),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Scrollable Recent Values
           Container(
  width: 500,
  margin: const EdgeInsets.only(left: 16.0),
  decoration: BoxDecoration(
    color: Colors.grey[900],
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: Consumer<DataManager>(
    builder: (context, dataManager, _) {
      final sensors = ["Dissolved Oxygen", "Optical Density", "pH Level", "Liquid Temperature"];
      final sensorKeys = ['pbr1_do', 'pbr1_od', 'pbr1_ph', 'pbr1_temp_l'];

      return ListView.builder(
        itemCount: sensors.length,
        itemBuilder: (context, index) {
          final sensorName = sensors[index];
          final sensorKey = sensorKeys[index];
          final recentValues = dataManager.getData(sensorKey)?.reversed.take(1000).toList() ?? [];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sensorName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255), 
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255), 
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    itemCount: recentValues.length,
                    itemBuilder: (context, valueIndex) {
                      final value = recentValues[valueIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          '${valueIndex + 1}: Value:${value['value']} Time: ${value['time']}', 
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      );
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
  /// Builds a container field displaying a label and a value, styled with a given background color.
  /// This is primarily used for displaying measurement values on the middle screen.
  ///
  /// - `label`: The text to display as the field's title or description. It is styled in bold.
  /// - `value`: The text to display as the field's main content. It represents the measurement value.
  /// - `color`: The background color of the container.
  ///
  /// The widget returns a styled [Container] with rounded corners. Inside the container,
  /// the `label` is displayed at the top, followed by the `value`, both vertically aligned.
  Widget _buildField(String label, String value, Color color) {
    return Container(
      width: 100,
      height: 80,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 16),
          ),
        ],
      ),
    );
  }
}
