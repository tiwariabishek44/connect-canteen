import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/common/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showNotLoggedInDialog() {
  Get.dialog(AlertDialog(
    title: const Text(
      'Login First!',
    ),
    content: Text(
      'You need to be logged in.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.sp),
    ),
    icon: const Icon(Icons.login),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          'Cancel',
          style: TextStyle(color: AppColors.primaryColor, fontSize: 16.sp),
        ),
      ),
      TextButton(
          onPressed: () {
            Get.offAll(() => const LoginView());
          },
          child: Text(
            'Login',
            style: TextStyle(color: AppColors.primaryColor, fontSize: 16.sp),
          ))
    ],
  ));
}
