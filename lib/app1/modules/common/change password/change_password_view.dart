import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../widget/textFormField.dart';
import 'change_password_controller.dart';

class ChangePasswordView extends StatelessWidget {
  final changePasswordController = Get.put(ChangePasswordController());

  ChangePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Change your password',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 5.h),
              Icon(
                Icons.lock,
                size: 8.h,
                color: Colors.grey,
              ),
              const SizedBox(height: 20.0),
              Text(
                'Enter your old and new password.',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Center(
                child: Form(
                    key: changePasswordController.changePasswordKey,
                    child: Column(
                      children: [
                        Obx(
                          () => TextFormFieldWidget(
                            obscureText: !changePasswordController
                                .isOldPasswordVisible.value,
                            textInputType: TextInputType.text,
                            hintText: "Old Password",
                            controller:
                                changePasswordController.oldPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                changePasswordController
                                        .isOldPasswordVisible.value =
                                    !changePasswordController
                                        .isOldPasswordVisible.value;
                              },
                              icon: Icon(
                                changePasswordController
                                        .isOldPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validatorFunction: (value) {
                              if (value.isEmpty) {
                                return "Old Password is required";
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
                            obscureText: !changePasswordController
                                .isNewPasswordVisible.value,
                            textInputType: TextInputType.text,
                            hintText: "New Password",
                            controller:
                                changePasswordController.newPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                changePasswordController
                                        .isNewPasswordVisible.value =
                                    !changePasswordController
                                        .isNewPasswordVisible.value;
                              },
                              icon: Icon(
                                changePasswordController
                                        .isNewPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validatorFunction: (value) {
                              if (value.isEmpty) {
                                return "New Password is required";
                              }
                              if (value.length < 8) {
                                return "New Password length must be atleast 8 digit";
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
                            obscureText: !changePasswordController
                                .iscPasswordVisible.value,
                            textInputType: TextInputType.text,
                            hintText: "Confirm Password",
                            controller: changePasswordController
                                .confirmPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                changePasswordController
                                        .iscPasswordVisible.value =
                                    !changePasswordController
                                        .iscPasswordVisible.value;
                              },
                              icon: Icon(
                                changePasswordController
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
                                  changePasswordController
                                      .newPasswordController.text) {
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
                    changePasswordController.checkValidation();
                  },
                  isLoading:
                      changePasswordController.ischangePasswordLoading.value))
            ],
          ),
        ),
      ),
    );
  }
}
