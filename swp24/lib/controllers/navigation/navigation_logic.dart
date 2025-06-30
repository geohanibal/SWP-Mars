import 'package:flutter/material.dart';
import '../../views/pages/chat_page/chat_screen.dart';
import '../../views/pages/home_page/home_page.dart';
import '../../views/pages/info_page/info_page.dart';
import '../../views/pages/setting_page/settings_page.dart';
import '../../views/pages/sensor_board_page/sensor_board_page.dart';
import '../../views/pages/sensor_board_page/sensor_board_1/sensor_board_1.dart';
import '../../views/pages/sensor_board_page/sensor_board_2/sensor_board_2.dart';
import '../../views/pages/sensor_board_page/sensor_board_3/sensor_board_3.dart';
import '../../views/pages/sensor_board_page/sensor_board_4/sensor_board_4.dart';
import '../../views/pages/photobioreactor_board_page/photobioreactor_board_page.dart';
import '../../views/pages/photobioreactor_board_page/nutrient_medium_page/nutrient_medium_page.dart';
import '../../views/pages/photobioreactor_board_page/gas_outlet_page/gas_outlet_page.dart';
/// Author: Sergi Koniashvili
/// 
/// This file contains the `NavigationLogic` class, which is responsible 
/// for managing navigation across the application. The class defines 
/// all available routes and provides a utility method to navigate between 
/// the different pages of the application.
class NavigationLogic {
  /// A map of all the routes in the application.
  /// 
  /// Each route is defined as a key-value pair, where the key is the route name
  /// (a [String]) and the value is a function that returns the corresponding
  /// [Widget].
  static final routes = {
    '/': (context) => const HomePage(),
    '/settings': (context) => const SettingsPage(),
    '/info': (context) => const InfoPage(),
    '/chat': (context) => const ChatScreen(), // დაამატე ChatScreen
    '/sensorboard': (context) => const SensorBoardPage(),
    '/sensorboard/sensor_board_1': (context) => const SensorBoard1(),
    '/sensorboard/sensor_board_2': (context) => const SensorBoard2(),
    '/sensorboard/sensor_board_3': (context) => const SensorBoard3(),
    '/sensorboard/sensor_board_4': (context) => const SensorBoard4(),
    '/photobioreactor': (context) => const PhotobioreactorBoardPage(),
    '/photobioreactor/nutrient_medium' : (context) => const NutrientMediumPage(),
    '/photobioreactor/gas_outlet': (context) => const GasOutletPage(),
  };
  
  /// Navigates to a specific route.
  /// 
  /// This method takes the current [BuildContext] and the name of the route
  /// as a [String], and navigates to the corresponding page.
  /// 
  /// Example:
  /// 
  /// ```dart
  /// NavigationLogic.navigateTo(context, '/settings');
  /// ```
  /// 
  /// - [context]: The current [BuildContext].
  /// - [route]: The name of the route to navigate to.
  static void navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}
