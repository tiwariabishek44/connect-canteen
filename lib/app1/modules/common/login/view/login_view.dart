import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/forget_password/forget_password_view.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:connect_canteen/app1/modules/common/registration/view/registration_view.dart';
import 'package:connect_canteen/app1/modules/common/registration/view/school_choose.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/textFormField.dart';
import 'package:connect_canteen/app1/widget/welcome_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final loginController = Get.put(LoginController());
  final loginOptionController = Get.put(LoginOptionController());

  final storage = GetStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Form(
            key: loginController.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Obx(() => WelcomeHeading(
                    mainHeading: 'Welcome to Connect Canteen',
                    subHeading:
                        "Login As ${loginOptionController.isStudent.value ? 'Student' : 'Canteen'}")),
                TextFormFieldWidget(
                  textInputType: TextInputType.text,
                  hintText: "Email",
                  controller: loginController.emailController,
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
                  height: 3.h,
                ),
                Obx(
                  () => TextFormFieldWidget(
                    prefixIcon: const Icon(Icons.lock),
                    textInputType: TextInputType.text,
                    hintText: 'Password',
                    controller: loginController.passwordController,
                    obscureText: !loginController.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        loginController.isPasswordVisible.value =
                            !loginController.isPasswordVisible.value;
                      },
                      icon: Icon(
                        loginController.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    validatorFunction: (value) {
                      if (value.isEmpty) {
                        return 'Enter the password';
                      }
                      return null;
                    },
                    actionKeyboard: TextInputAction.done,
                    onSubmitField: () {},
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.off(() => ForgetPasswordView());
                      },
                      child: Text("Forgot Password?",
                          style: TextStyle(
                            color: const Color(0xff6A707C),
                            fontSize: 15.sp,
                          )),
                    ),
                  ),
                ),
                Obx(
                  () => CustomButton(
                    text: "Login",
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      loginController.userLogin();
                    },
                    isLoading: loginController.isLoginLoading.value,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 217, 214, 214),
                          height: 0.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff6A707C),
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 217, 214, 214),
                          height: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Get.to(() => SchoolChoose());
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    loginController.emailController.dispose();
    loginController.passwordController.dispose();
    super.dispose();
  }
}
