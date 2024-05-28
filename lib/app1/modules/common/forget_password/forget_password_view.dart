import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/common/forget_password/forget_password_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../widget/textFormField.dart';
import '../login/view/login_view.dart';

class ForgetPasswordView extends StatelessWidget {
  final forgetPasswordController = Get.put(ForgetPasswordController());

  ForgetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offAll(() => const LoginView());
            },
          ),
          title: const Text(
            'Forgot Password',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 5.h),
              Icon(
                Icons.lock,
                size: 10.h,
                color: AppColors.primaryColor,
              ),
              // SizedBox(height: 20.0),
              Text(
                'Forgot Your Password ?',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                'Enter your email address below and new password.',
                style: TextStyle(
                  fontSize: 17.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Center(
                child: Form(
                    key: forgetPasswordController.forgetPasswordKey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          textInputType: TextInputType.text,
                          hintText: "Email",
                          controller: forgetPasswordController.emailController,
                          validatorFunction: (value) {
                            if (value.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          actionKeyboard: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Obx(
                          () => TextFormFieldWidget(
                            obscureText: forgetPasswordController
                                .isPasswordVisible.value,
                            textInputType: TextInputType.text,
                            hintText: "Password",
                            controller:
                                forgetPasswordController.passwordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                forgetPasswordController
                                        .isPasswordVisible.value =
                                    !forgetPasswordController
                                        .isPasswordVisible.value;
                              },
                              icon: Icon(
                                forgetPasswordController.isPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validatorFunction: (value) {
                              if (value.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 8) {
                                return "Password length must be atleast 8 digit";
                              }
                              return null;
                            },
                            actionKeyboard: TextInputAction.next,
                            prefixIcon: const Icon(Icons.security),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Obx(
                          () => TextFormFieldWidget(
                            obscureText: forgetPasswordController
                                .iscPasswordVisible.value,
                            textInputType: TextInputType.text,
                            hintText: "Confirm Password",
                            controller: forgetPasswordController
                                .confirmPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                forgetPasswordController
                                        .iscPasswordVisible.value =
                                    !forgetPasswordController
                                        .iscPasswordVisible.value;
                              },
                              icon: Icon(
                                forgetPasswordController
                                        .iscPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validatorFunction: (value) {
                              if (value.isEmpty) {
                                return "Confirm Password is required";
                              }
                              if (value.length < 8) {
                                return "Confirm Password length must be atleast 8 digit";
                              }
                              if (value !=
                                  forgetPasswordController
                                      .passwordController.text) {
                                return "Confirm password must match password";
                              }
                              return null;
                            },
                            actionKeyboard: TextInputAction.next,
                            prefixIcon: const Icon(Icons.security),
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(height: 5.h),
              Obx(() => CustomButton(
                  text: "Submit",
                  onPressed: () {
                    forgetPasswordController.checkValidation();
                  },
                  isLoading:
                      forgetPasswordController.isforgetPasswordLoading.value))
            ],
          ),
        ),
      ),
    );
  }
}
