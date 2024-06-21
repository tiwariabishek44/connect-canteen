import 'dart:async';
import 'dart:developer';

import 'package:connect_canteen/app/modules/canteen_helper/helper%20main%20screen/main_screen.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/modules/canteen_helper/helper_main_screen/helper_main.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/canteen_main_screen/canteen_main_screen.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option.dart';
import 'package:connect_canteen/app1/modules/student_modules/student_mainscreen/student_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../login/login_controller.dart';

class SplashScreen1 extends StatefulWidget {
  SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  final loginController = Get.put(LoginController());
  final storage = GetStorage();

  void handleMainScreen() async {
    log(" this is the user type ${storage.read(userTypes)}");
    if (storage.read(userTypes) == 'student') {
      Get.offAll(() => StudentMainScreenView());
    } else if (storage.read(userTypes) == 'canteen') {
      Get.offAll(() => CanteenMainScreen());
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      loginController.autoLogin()
          ? handleMainScreen()
          : Get.offAll(() => OnboardingScreen());
    });
  }

  //---------------Load Home page data---------------//
  void loadData(var accessToken) async {}

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

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
