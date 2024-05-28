import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../cons/colors.dart';

void getSnackBar({String? message, Color? bgColor, IconData? leadingIcon}) =>
    Get.showSnackbar(
      GetSnackBar(
        onTap: (value) {
          Get.back();
        },
        duration: const Duration(milliseconds: 3000),
        message: message ?? "Message",
        animationDuration: const Duration(milliseconds: 600),
        isDismissible: true,
        shouldIconPulse: false,
        dismissDirection: DismissDirection.endToStart,
        icon: Icon(
          leadingIcon,
          color: Colors.white,
        ),
        backgroundColor: bgColor ?? AppColors.primaryColor,
      ),
    );
