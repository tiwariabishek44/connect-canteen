import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option.dart';
import 'package:connect_canteen/app1/modules/student_modules/student_mainscreen/student_main_screen.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var termsAndConditions = false.obs;
  var isPasswordVisible = false.obs;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final storage = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Observable for student data response
  final studentDataResponse = Rxn<StudentDataResponse?>();

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void userLogin() {
    if (loginFormKey.currentState!.validate()) {
      dologin();
    }
  }

  var isLoginLoading = false.obs;

  void dologin() async {
    try {
      isLoginLoading.value = true;
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Save user ID to local storage
      storage.write(userId, _auth.currentUser!.uid);
      isLoginLoading.value = false;

      Get.offAll(() => StudentMainScreenView());
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      isLoginLoading.value = false;

      if (e.code == 'user-not-found') {
        CustomSnackbar.error(Get.context!, 'User Not Fount');
      } else if (e.code == 'wrong-password') {
        CustomSnackbar.error(Get.context!, 'Wrong Password');
      } else if (e.code == 'invalid-credential') {
        log(e.code);
        CustomSnackbar.error(Get.context!, 'User is not Register ');
      }
    } catch (e) {
      CustomSnackbar.error(Get.context!, 'Something went wrong');
      // Handle other errors
    }
  }

//----------- TO FETCH THE STUDETN DATA


  Stream<StudentDataResponse?> getStudetnData() {
    return _firestore
        .collection(ApiEndpoints.prodcutionStudentCollection)
        .where('userid', isEqualTo: storage.read(userId))
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        studentDataResponse.value = StudentDataResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);

        // Assuming that userId is unique and there will be only one document
        return StudentDataResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

//-------to do auto login---------
  bool autoLogin() {
    if (storage.read(userId) != null) {
      // set a periodic timer to refresh token
      return true;
    }
    return false;
  }

//--to do logout------------------
  Future<void> logout() async {
    try {
      await _auth.signOut();
      storage.remove(
        userId,
      );

      Get.offAll(() => OnboardingScreen());
    } catch (e) {
      // Handle logout errors
      Get.snackbar("Logout Failed", e.toString());
    }
  }
}
