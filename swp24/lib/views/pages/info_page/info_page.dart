import 'package:flutter/material.dart';
import '../../../../controllers/navigation/navigation_logic.dart';

/// A stateless widget that represents the InfoPage.
/// 
/// This page provides information about the software project, including the title, team members,
/// and a brief description of the project.
class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Software Project WiSe 2024/2025',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // AppBar color
      ),
      body: Row(
        children: [
          // Left navigation panel
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
                _buildNavItem(
                  context,
                  route: '/photobioreactor',
                  icon: Icons.biotech,
                  label: 'Photobioreactor',
                ),
                _buildNavItem(
                  context,
                  route: '/chat',
                  icon: Icons.chat,
                  label: 'Chat',
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text(
                      'Graphical User Interface for an Extraterrestrial Habitat',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'This project was developed by the following students:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
                  // List of students
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      '1. Jan Golombiewski\n'
                      '2. Giacomo Gargula\n'
                      '3. Faridoon Noori\n'
                      '4. Sergi Koniashvili',
                      style: TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Thank you for your interest!',
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurple[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Icon(
                          Icons.thumb_up,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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