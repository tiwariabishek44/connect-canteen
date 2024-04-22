import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/forget_password/forget_password_controller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:connect_canteen/app/widget/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordPage({super.key});
  final forgetPasswordController = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Form(
            key: forgetPasswordController.forgetPasswordKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Forget password",
                  style: AppStyles.mainHeading,
                ),
                SizedBox(
                  height: 5.h,
                ),
                CustomizedTextfield(
                  keyboardType: TextInputType.emailAddress,
                  validator: forgetPasswordController.emailValidator,
                  icon: Icons.email_outlined,
                  myController: forgetPasswordController.emailoCntroller1,
                  hintText: "Enter Email",
                ),
                SizedBox(height: 2.h),
                Text(
                  "We'll send the verification likn to this email if it matches an existing Connect Canteen account",
                  style: AppStyles.listTilesubTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                Obx(() => CustomButton(
                    text: 'Send',
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      forgetPasswordController.sendOtp();
                    },
                    isLoading: forgetPasswordController.isloading.value))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
