import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lidar/presentation/screens/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/bindings/bindings.dart';
import 'app/utils/secrets.dart';
import 'app/utils/theme.dart';

void main()  async {
  await Supabase.initialize(
    url: Secrets.supabaseUrl,
    anonKey: Secrets.supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'YAP',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,

      home:  OnboardingScreen(),
    );
  }
}


