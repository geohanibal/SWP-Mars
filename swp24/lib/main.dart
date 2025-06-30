import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/notification_manager/norification_manager.dart';
import 'services/mqtt/mqtt.dart'; // MQTT ფუნქციები
import 'controllers/navigation/navigation_logic.dart'; // Navigation Logic
import 'services/influxdb/fetch_data.dart';
import 'services/data_manager/data_manager.dart';
import 'models/mqttStateNotifier/mqtt_state_notifier.dart';
import 'models/clockModel/clock_model.dart';

/// Main entry point of the app
/// Author: Sergi Koniashvili
/// This app initializes MQTT, InfluxDB, and state management providers to manage
/// communication, data fetching, and overall application logic.
void main() async{
  // Ensure widgets are initialized before starting the app
  WidgetsFlutterBinding.ensureInitialized();

  final mqttConnectionStatus = MqttConnectionStatus();
  // MQTT client configuration
  setupMqttClient(mqttConnectionStatus);

  // Fetch initial data from InfluxDB
  await InfluxDBService.fetchData();
  // App start
  runApp(AppInitializer(mqttConnectionStatus: mqttConnectionStatus));
}

/// AppInitializer
/// Author: Sergi Koniashvili
/// This widget initializes the necessary providers and the overall app setup.
class AppInitializer extends StatelessWidget {
  final MqttConnectionStatus mqttConnectionStatus;

  const AppInitializer({Key? key, required this.mqttConnectionStatus}) : super(key: key);

@override
  Widget build(BuildContext context) { 
    return MultiProvider(
      providers: [
        // MQTT connection status provider
        ChangeNotifierProvider.value(value: mqttConnectionStatus),
        // Notification manager provider
        ChangeNotifierProvider(create: (_) => NotificationManager()),
        // Clock "real-time" model provider
        ChangeNotifierProvider(create: (_) => ClockModel()),
        // Data manager provider
        ChangeNotifierProvider(create: (_) => DataManager()),
      ],
      child: Builder(
        builder: (context) { //context that is created and shared between the application
          Future.microtask(() async {
            await InfluxDBService.processLatestValuesOnStartup(context);
          });
          setupMqttClient(mqttConnectionStatus);
          listenToSensorUpdates(context); 
          return const HabitatApp();
        },
      ),
    );
  }
}

/// HabitatApp
/// Author: Sergi Koniashvili
/// The main widget of the application, which initializes routes, themes, and the UI.
class HabitatApp extends StatelessWidget {
  const HabitatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitat App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary theme color
        primaryColor: const Color.fromARGB(137, 220, 218, 218), // Custom primary color
      ),
      initialRoute: '/', // Default starting route, also homepage
      routes: NavigationLogic.routes, // Define the route logic for navigation
    );
  }
}
