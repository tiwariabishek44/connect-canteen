import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/snackbar_widget.dart';

class ForgetPasswordController extends GetxController {
  final GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var isPasswordVisible = false.obs;
  var iscPasswordVisible = false.obs;
  var isforgetPasswordLoading = false.obs;

  void checkValidation() async {
    if (!forgetPasswordKey.currentState!.validate()) {
      log("invalid");
      return;
    }
    forgetPassword();
  }

  // @override
  // void dispose() {
  //   log("Dispose of controllers of forget password");
  //   confirmPasswordController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  void forgetPassword() async {
    isforgetPasswordLoading.value = true;
    final reqbody = {
      "newPassword": passwordController.text,
      "confirmPassword": confirmPasswordController.text,
    };
  }
}
