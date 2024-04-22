import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/forget_password/forget_password_page.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/common/loginoption/login_option_controller.dart';
import 'package:connect_canteen/app/modules/common/register/register.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:connect_canteen/app/widget/customized_textfield.dart';
import 'package:connect_canteen/app/widget/welcome_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginAsCanteenHelper extends StatefulWidget {
  @override
  State<LoginAsCanteenHelper> createState() => _LoginAsCanteenHelperState();
}

class _LoginAsCanteenHelperState extends State<LoginAsCanteenHelper> {
  final logincontroller = Get.put(LoginController());
  final loginScreenController = Get.put(LoginScreenController());
  final storage = GetStorage();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Form(
            key: logincontroller.helperFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                WelcomeHeading(
                  mainHeading: 'Welcome to HamroCanteen',
                  subHeading: "Login AS Canteen Helper",
                ),
                SizedBox(height: 10),
                CustomizedTextfield(
                  keyboardType: TextInputType.emailAddress,
                  validator: logincontroller.emailValidator,
                  icon: Icons.email_outlined,
                  myController: logincontroller.emailcontroller,
                  hintText: "Email Id",
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.7.h),
                  child: TextFormField(
                    validator: logincontroller.passwordValidator,
                    controller: logincontroller.passwordcontroller,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 20.sp,
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: AppColors.secondaryColor, fontSize: 17.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.secondaryColor, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.secondaryColor, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off_outlined,
                          color: AppColors.secondaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Obx(() => CustomButton(
                    text: "Helper Login",
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      logincontroller.loginSubmit(context);
                    },
                    isLoading: logincontroller.isloading.value)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
