// reg controller

import 'dart:developer';

import 'package:connect_canteen/app1/data/api_models/register_api_response.dart';
import 'package:connect_canteen/app1/services/api_client.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class RegisterController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var isPasswordVisible = false.obs;
  var iscPasswordVisible = false.obs;

  var termsAndConditions = false.obs;
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Check validation for the inputs for login
  void userRegister(BuildContext context) {
    if (termsAndConditions.value != true) {
      CustomSnackbar.show(context, "Agree to read terms and conditions");

      return;
    }
    if (!registerFormKey.currentState!.validate()) {
      log("invalid");
      return;
    }

    doRegister(context);
  }

  var isRegisterLoading = false.obs;
  var registerApiResponse = ApiResponse<RegisterResponse>.initial().obs;

  void doRegister(BuildContext context) async {
    isRegisterLoading.value = true;
    final reqbody = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "mobileNumber": mobileNumberController.text,
      "password": passwordController.text,
      "confirmPassword": confirmPasswordController.text,
    };
  }
  // You can add other methods or logic related to registration here
}
