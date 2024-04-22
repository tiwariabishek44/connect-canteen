import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  //-------- FOR FROGET PASSWORD-------
  final forgetPasswordKey = GlobalKey<FormState>();

  final emailoCntroller1 = TextEditingController();
  var isloading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendOtp() {
    if (forgetPasswordKey.currentState!.validate()) {
      resetPassword();
    }
  }

  Future<void> resetPassword() async {
    try {
      isloading(true);
      await _auth.sendPasswordResetEmail(email: emailoCntroller1.text.trim());
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text("Password reset email sent"),
      ));
    } catch (error) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text("${error.toString()}"),
      ));
    } finally {
      isloading(
          false); // Set loading state to false regardless of success or failure
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    // Check if the entered email has the right format
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    // Return null if the entered email is valid
    return null;
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    emailoCntroller1.dispose();

    super.onClose();
  }
}
