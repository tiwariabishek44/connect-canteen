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

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final registercontroller = Get.put(RegisterController());
  final loginOptionController = Get.put(LoginOptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "As ${loginOptionController.isStudent.value ? 'Student' : 'Canteen'}"),
            Text(
              "",
              style: TextStyle(color: AppColors.primaryColor, fontSize: 20.sp),
            ),
            SizedBox(
              height: 4.h,
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
                      hintText: 'First Name',
                      controller: registercontroller.firstNameController,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'First Name Can\'t be empty';
                        }
                        return null;
                      },
                      actionKeyboard: TextInputAction.next,
                      onSubmitField: () {},
                    ),
                    SizedBox(height: 2.h),
                    TextFormFieldWidget(
                      prefixIcon: const Icon(Icons.person),
                      textInputType: TextInputType.text,
                      hintText: 'Last Name',
                      controller: registercontroller.lastNameController,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'Last Name Can\'t be empty';
                        }
                        return null;
                      },
                      actionKeyboard: TextInputAction.next,
                      onSubmitField: () {},
                    ),
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
                      textInputType: TextInputType.text,
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
                        textInputType: TextInputType.text,
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
                              value:
                                  registercontroller.termsAndConditions.value,
                              onChanged: (value) {
                                registercontroller.termsAndConditions.value =
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
                    Obx(() => CustomButton(
                          text: "Register",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            registercontroller.userRegister(context);
                          },
                          isLoading: registercontroller.isRegisterLoading.value,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
