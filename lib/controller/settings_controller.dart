import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<User?> user = Rx<User?>(null);
  final RxString email = ''.obs;

  @override
  void onInit() {
    user.value = _auth.currentUser;
    email.value = user.value?.email ?? '';
    super.onInit();
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await user.value?.updateEmail(newEmail);
      email.value = newEmail;
      await _firestore.collection('users').doc(user.value?.uid).update({'email': newEmail});
      Get.snackbar('Success', 'Email updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update email: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await user.value?.updatePassword(newPassword);
      Get.snackbar('Success', 'Password updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password: $e');
    }
  }
}