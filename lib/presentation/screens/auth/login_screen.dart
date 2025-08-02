import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../widgets/social_login_button.dart';
import '../main_scaffold.dart';
import 'signup_screen.dart';
import '../../widgets/text_field_box.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => MainScaffold()),
              child: Text(
                'CivicTrack',
                style: GoogleFonts.pacifico(
                  fontSize: 40,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextFieldBox(
              controller: authController.emailController,
              hint: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 20),
            TextFieldBox(
              controller: authController.passwordController,
              hint: 'Password',
              icon: Icons.lock,
              isObscure: true,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: authController.isLoading.value
                    ? null
                    : () => authController.logIn(),
                child: authController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign in'),
              ),
            )),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                ),
                GestureDetector(
                  onTap: () => Get.offAll(() => const SignUpPage()),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'or sign in with',
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                socialLoginButton('assets/auth/google.png', () {}),
                socialLoginButton('assets/auth/facebook.png', () {}),
                socialLoginButton('assets/auth/apple.png', () {}),
                socialLoginButton('assets/auth/x.png', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}