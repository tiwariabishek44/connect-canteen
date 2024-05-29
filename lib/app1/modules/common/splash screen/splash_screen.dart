import 'dart:async';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option.dart';
import 'package:connect_canteen/app1/modules/student_modules/student_mainscreen/student_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../login/login_controller.dart';
import '../login/view/login_view.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final loginController = Get.put(LoginController());
  final storage = GetStorage();

  // void handleMainScreen() async {
  //   if (storage.read(userType) == student) {
  //     await logincontroller.fetchUserData();
  //     if (logincontroller
  //         .userDataResponse.value.response!.first.groupid.isNotEmpty) {
  //       groupController.fetchGroupData();
  //     }

  //     logincontroller.userDataResponse.value.response!.isNotEmpty
  //         ? Get.offAll(() => UserMainScreenView())
  //         : log("some went wrong");
  //   } else if (storage.read(userType) == canteenhelper) {
  //     Get.offAll(() => HelperMainScreen());
  //   } else {
  //     Get.offAll(() => CanteenMainScreenView());
  //   }
  // }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      loginController.autoLogin()
          ? Get.offAll(() => StudentMainScreenView())
          : Get.offAll(() => OnboardingScreen());
    });
  }

  //---------------Load Home page data---------------//
  void loadData(var accessToken) async {}

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/splash.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 70.h,
              left: 43.w,
              child: SpinKitFadingCircle(
                color: AppColors.backgroundColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
