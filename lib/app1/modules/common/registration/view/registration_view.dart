import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:connect_canteen/app1/modules/common/registration/registration_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/welcome_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../widget/textFormField.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final registercontroller = Get.put(RegisterController());

  final loginOptionController = Get.put(LoginOptionController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.backgroundColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_sharp),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                WelcomeHeading(
                    mainHeading: "Create an Account",
                    subHeading:
                registercontroller.schoolname.value),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: AppPadding.screenHorizontalPadding,
                  child: Form(
                    key: registercontroller.registerFormKey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          prefixIcon: const Icon(Icons.person),
                          textInputType: TextInputType.text,
                          hintText: 'Name',
                          controller: registercontroller.nameController,
                          validatorFunction: (value) {
                            if (value.isEmpty) {
                              return '  Name Can\'t be empty';
                            }
                            return null;
                          },
                          actionKeyboard: TextInputAction.next,
                          onSubmitField: () {},
                        ),
                        SizedBox(height: 2.h),
                        
                        SizedBox(height: 2.h),
                        TextFormFieldWidget(
                          prefixIcon: const Icon(Icons.email),
                          textInputType: TextInputType.emailAddress,
                          hintText: 'Email',
                          controller: registercontroller.emailController,
                          validatorFunction: (value) {
                            if (value.isEmpty) {
                              return 'Email Name Can\'t be empty';
                            }

                            return null;
                          },
                          actionKeyboard: TextInputAction.next,
                          onSubmitField: () {},
                        ),
                        SizedBox(height: 2.h),
                        TextFormFieldWidget(
                          prefixIcon: const Icon(Icons.phone),
                          textInputType: TextInputType.number,
                          hintText: 'Mobile Number',
                          controller: registercontroller.mobileNumberController,
                          validatorFunction: (value) {
                            if (value.isEmpty) {
                              return 'Mobile number Can\'t be empty';
                            }
                            if (value.length < 10) {
                              return 'Mobile number must contain  10 character';
                            }
                            return null;
                          },
                          actionKeyboard: TextInputAction.next,
                          onSubmitField: () {},
                        ),
                        SizedBox(height: 2.h),
                        Obx(
                          () => TextFormFieldWidget(
                            prefixIcon: const Icon(Icons.lock),
                            textInputType: TextInputType.visiblePassword,
                            hintText: 'Password',
                            controller: registercontroller.passwordController,
                            obscureText:
                                !registercontroller.isPasswordVisible.value,
                            suffixIcon: IconButton(
                              onPressed: () {
                                registercontroller.isPasswordVisible.value =
                                    !registercontroller.isPasswordVisible.value;
                              },
                              icon: Icon(
                                registercontroller.isPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validatorFunction: (value) {
                              if (value.isEmpty) {
                                return 'Enter the password';
                              }
                              if (value.length < 8) {
                                return 'Password must contain atleast 8 character';
                              }
                              return null;
                            },
                            actionKeyboard: TextInputAction.next,
                            onSubmitField: () {},
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 2.h,
                        ),
                        Obx(
                          () => Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                                child: Checkbox(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    return Colors
                                        .white; // Change this to the default color you want.
                                  }),
                                  checkColor: AppColors.primaryColor,
                                  focusColor: AppColors.primaryColor,
                                  value: registercontroller
                                      .termsAndConditions.value,
                                  onChanged: (value) {
                                    registercontroller
                                            .termsAndConditions.value =
                                        !registercontroller
                                            .termsAndConditions.value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 70.w,
                                child: RichText(
                                  maxLines: 4,
                                  text: TextSpan(
                                    text: "I have read and agreed to the ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Terms and Conditions",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          text: "Register",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            registercontroller.userRegister(context);
                          },
                          isLoading: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))),
        Obx(() => registercontroller.isRegisterLoading.value
            ? Positioned(
                left: 40.w, top: 50.h, child: Center(child: LoadingWidget()))
            : SizedBox.shrink())
      ],
    );
  }
}
