import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lidar/presentation/screens/issuess_map_screen.dart';
import 'package:lidar/presentation/screens/profile/profile_screen.dart';

import '../../app/controllers/nav_controller.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';

class MainScaffold extends StatelessWidget {
  MainScaffold({super.key});

  final NavController navController = Get.find();

  final List<Widget> screens = [
     HomeScreen(),
     IssuesMapScreen(),
     ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: screens[navController.selectedIndex.value],
      bottomNavigationBar: BottomNavBar(navController: navController),
    ));
  }
}