import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../../../services/mqtt/mqtt.dart';
import '../../../models/chatModel/chat_message.dart';
import '../../../models/mqttStateNotifier/mqtt_state_notifier.dart';
import '../../../models/clockModel/clock_model.dart';
import '../../widgets/chat_page/chat_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../../services/notification_manager/norification_manager.dart';
import '../../../controllers/navigation/navigation_logic.dart';
import '../../widgets/home_page/bottom_nav_bar.dart';

/// ChatScreen is a stateful widget that represents the chat interface, where you can send and receive messages from the specified topics.
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = []; // List of chat messages
  final TextEditingController _controller = TextEditingController(); // Controller for the text input

  /// Saves chat messages to persistent storage using SharedPreferences.
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = _messages
        .map((message) => {
              'text': message.text,
              'sender': message.sender,
              'timestamp': message.timestamp.toIso8601String(),
            })
        .toList();
    await prefs.setString('chat_messages', jsonEncode(messagesJson));
  }

  /// Loads chat messages from persistent storage and populates the message list.
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString('chat_messages');
    if (messagesString != null) {
      final messagesJson = jsonDecode(messagesString) as List;
      setState(() {
        _messages.clear();
        _messages.addAll(messagesJson.map((json) => ChatMessage(
              text: json['text'],
              sender: json['sender'],
              timestamp: DateTime.parse(json['timestamp']),
            )));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();

    // Subscribe to the MQTT topic and listen for updates from the topic 'chatbot/mission_control'.
    client.subscribe('chatbot/mission_control', MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      final recMessage = events[0];
      final topic = recMessage.topic;
      final payload = MqttPublishPayload.bytesToStringAsString(
          (recMessage.payload as MqttPublishMessage).payload.message);

      if (topic == 'chatbot/mission_control') {
        setState(() {
          _messages.add(ChatMessage(
            text: payload,
            sender: 'server',
            timestamp: DateTime.now(),
          ));
        });
        _saveMessages();
      }
    });
  }

  /// Sends a message to the MQTT server and updates the UI through the topic 'chat/user'.
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    sendMessage('chat/user', _controller.text.trim());

    setState(() {
      _messages.add(ChatMessage(
        text: _controller.text.trim(),
        sender: 'user',
        timestamp: DateTime.now(),
      ));
    });
    _saveMessages();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final mqttStatus = context.watch<MqttConnectionStatus>().status; // Current MQTT connection status
    final currentTime = context.watch<ClockModel>().currentTime; // Current time from ClockModel

    return Scaffold(
      body: Row(
        children: [
          // Left Navigation Bar
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

          // Middle Area (Chat Section)
          Expanded(
            child: Container(
              color: Colors.grey[800],
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[_messages.length - 1 - index];
                        return ChatBubble(message: message);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white), // Change text color
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Colors.white54), // Placeholder text style
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
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
    // Filter notifications for the given type
    final filteredNotifications = notifications.where((n) => n['type'] == type).toList();

    if (filteredNotifications.any((n) => n['status'] == 'Critical')) {
      // If there is at least one critical notification
      return Colors.red;
    } else if (filteredNotifications.any((n) => n['status'] == 'Warning')) {
      // If there are only warnings
      return Colors.yellow;
    } else {
      // If there are no relevant notifications
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
    final currentRoute = ModalRoute.of(context)?.settings.name; // Current path
    final isActive = currentRoute == route; // Check if the route is active

    return Tooltip(
      message: label,
      child: Container(
        color: isActive ? Colors.blue : Colors.transparent, // Active color
        child: IconButton(
          icon: Icon(icon, color: isActive ? Colors.white : Colors.grey[500]),
          onPressed: () {
            if (!isActive) {
              Navigator.pushNamed(context, route);
            }
          },
        ),
      ),
    );
  }
}
