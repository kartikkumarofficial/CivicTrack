import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'main_scaffold.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: Get.height*0.31,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome to CivicTrack!",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Connect to people you care about.",
                  style: GoogleFonts.barlow(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: outlinedButton(
                        "Create Account",
                            () => Get.offAll(() => const SignUpPage()),
                        context,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: outlinedButton(
                        "Sign In",
                            () => Get.offAll(() => const LoginPage()),
                        context,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      Get.offAll(() => MainScaffold());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Continue as Guest",
                      style: GoogleFonts.barlow(fontSize: 18, color: Colors.white),
                    ),
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

  Widget outlinedButton(String text, VoidCallback onTap, BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.barlow(
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}