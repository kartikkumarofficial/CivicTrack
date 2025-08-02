import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/main_scaffold.dart';

import 'user_controller.dart';

class AuthController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final UserController userController = Get.find<UserController>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match', colorText: Colors.white, backgroundColor: Colors.redAccent);
      return;
    }

    isLoading.value = true;
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          "name": name,
        },
      );

      if (response.user != null) {
        await supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'username': name,
          'profile_image':
          'https://api.dicebear.com/6.x/pixel-art/png?seed=work.kartikkumar@gmail.com',
        });
        await userController.fetchUserProfile();
        Get.snackbar(
          'Success',
          'Signed up as ${response.user!.email}, Confirm your email via the link in your inbox',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        Get.offAll(() => LoginPage());
      } else {
        Get.snackbar(
          'Sign Up Failed',
          'Something went wrong. Try again.',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
        );
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logIn() async {

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password cannot be empty',
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
      );
      return;
    }
    isLoading.value = true;

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await userController.fetchUserProfile();
        Get.snackbar(
          'Welcome',
          'Logged in as ${response.user!.email} ',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => MainScaffold());
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid Credentials',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
        );
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;

    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}