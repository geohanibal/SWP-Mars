import 'package:flutter/material.dart';

/// StatusBar
/// Author: Sergi Koniashvili
/// This widget displays a status bar that shows the current time, MQTT connection status,
/// and sensor status in a horizontal layout.
class StatusBar extends StatelessWidget {
  final String time; // Current time to display
  final String mqttStatus; // MQTT connection status
  final String sensorStatus; // Overall sensor status

  const StatusBar({
    Key? key,
    required this.time,
    required this.mqttStatus,
    required this.sensorStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.blueGrey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Time: $time', style: const TextStyle(fontSize: 14)),
          Text('MQTT: $mqttStatus', style: const TextStyle(fontSize: 14)),
          Text('Sensors: $sensorStatus', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
