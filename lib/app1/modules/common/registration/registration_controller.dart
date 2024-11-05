// reg controller

import 'dart:developer';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';

import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class UserRegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var schoolname = ''.obs;

  var isPasswordVisible = false.obs;
  var iscPasswordVisible = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  var termsAndConditions = false.obs;

  // Check validation for the inputs for login
  void userRegister(BuildContext context, String schoolName, String schoolId) {
    if (registerFormKey.currentState!.validate()) {
      registerUser(schoolName, schoolId);
      log(" inside the register user");
    }
  }

//-------Register Student-------
  var isRegisterLoading = false.obs;
  Future<void> registerUser(String schoolName, String schoolId) async {
    try {
      isRegisterLoading(true);

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection(ApiEndpoints.prodcutionStudentCollection)
          .doc(userCredential.user!.uid)
          .set({
        'userid': userCredential.user!.uid, // Saving userid
        'name': nameController.text,
        'phone': mobileNumberController.text,
        'email': emailController.text,
        'classes': '',
        "schoolId": schoolId,
        'schoolName': schoolName,
        'profilePicture': '',
        'creditScore': 5,
        'depositAmount': 0.0, // Initializing depositAmount with 0 balance
      });
      Get.back();
      DialogHelper.showSuccessDialog(
        title: 'Success!',
        message: 'Account created successfully.',
        onConfirm: () {
          Get.back();
        },
      );
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      isRegisterLoading.value = false;

      if (e.code == 'user-not-found') {
        CustomSnackbar.error(Get.context!, 'User Not Fount');
      } else if (e.code == 'wrong-password') {
        CustomSnackbar.error(Get.context!, 'Wrong Password');
      } else if (e.code == 'invalid-credential') {
        log(e.code);
        CustomSnackbar.error(Get.context!, 'User is not Register ');
      } else {
        log(e.code);
        CustomSnackbar.error(Get.context!, '${e.code}');
      }
    } catch (e) {
      isRegisterLoading(false);
      log("Error during user registration: $e");
      // Display an error message to the user
      // You can customize this based on your UI
      Get.snackbar(
        "Registration Failed",
        "An error occurred during registration.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    nameController.clear();
    emailController.clear();
    mobileNumberController.clear();
    passwordController.clear();

    super.onClose();
  }
}

class DialogHelper {
  static void showSuccessDialog({
    String title = 'Success!',
    String message = 'Action completed successfully.',
    VoidCallback? onConfirm,
  }) {
    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final theme = Theme.of(context);

        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success animation and header
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Success Icon with Animation
                      TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Message and action buttons
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: onConfirm,
                        child: Text('OK',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
