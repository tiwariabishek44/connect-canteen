import 'dart:developer';

import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../cons/prefs.dart';
import '../../../data/api_models/change_password_api_response.dart';
import '../../../widget/snackbar_widget.dart';

class ChangePasswordController extends GetxController {
  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final loginController = Get.put(LoginController());
  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var iscPasswordVisible = false.obs;
  var ischangePasswordLoading = false.obs;

  final storage = GetStorage();

  void checkValidation() async {
    if (!changePasswordKey.currentState!.validate()) {
      log("invalid");
      return;
    }
    changePassword();
  }

  // @override
  // void dispose() {
  //   log("Dispose of controllers of change password");
  //   confirmPasswordController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  void changePassword() async {
    log("change password api call");
    ischangePasswordLoading.value = true;
    final reqbody = {
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text,
      "confirmPassword": confirmPasswordController.text,
    };
  }
}
