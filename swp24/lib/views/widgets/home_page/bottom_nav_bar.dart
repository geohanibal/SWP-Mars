import 'package:flutter/material.dart';
import '../../../controllers/navigation/navigation_logic.dart';
/// BottomNavBar
/// Author: Sergi Koniashvili
/// This widget provides a bottom navigation bar with three options: Home, Settings, and Info.
/// Each option navigates to a specific page when selected.
class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Start',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Info',
        ),
      ],
      /// Handle item selection of the bottom bar to navigation to the according pages
      onTap: (index) {
        switch (index) {
          case 0:
            NavigationLogic.navigateTo(context, '/');
            break;
          case 1:
            NavigationLogic.navigateTo(context, '/settings');
            break;
          case 2:
            NavigationLogic.navigateTo(context, '/info');
            break;
        }
      },
    );
  }
}
