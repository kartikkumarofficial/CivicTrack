import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/screens/auth/login_screen.dart';


class UserController extends GetxController {
  final supabase = Supabase.instance.client;

  var userName = ''.obs;
  var profileImageUrl = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      if (user != null) {
        print('Logged-in User ID: ${user.id}');
        email.value = user.email ?? '';
        final response =
        await supabase.from('users').select().eq('id', user.id).single();
        print('User table response: $response');
        userName.value = response['username'] ?? 'username not provided';
        profileImageUrl.value =
            response['profile_image'] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9oq8vhrZWuASFrhOqfj4rPD0H-UKzzK2_tQ&s';
      }
    } catch (e) {
      print('Fetch user profile error: $e');
      Get.snackbar('Error', 'Failed to fetch user profile :${e.toString()}',colorText: Colors.white,);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage(String url) async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase
            .from('users')
            .update({'profile_image': url})
            .eq('id', user.id);
        profileImageUrl.value = url;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile image',colorText: Colors.white,);
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase
            .from('users')
            .update({'username': newName})
            .eq('id', user.id);
        userName.value = newName;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update username',colorText: Colors.white,);
    }
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      clearUserData();
      Get.offAll(() => LoginPage());
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout',colorText: Colors.white,);
    }
  }

  void clearUserData() {
    userName.value = '';
    profileImageUrl.value = '';
    email.value = '';
  }
}