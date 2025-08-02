import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/nav_controller.dart';
// import '../../controllers/nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.navController,
  });

  final NavController navController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      currentIndex: navController.selectedIndex.value,
      onTap: navController.changeTab,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      iconSize: 28,
      elevation: 4,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ));
  }
}