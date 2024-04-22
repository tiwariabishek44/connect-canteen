import 'dart:async';
import 'dart:developer';

import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app/modules/canteen_helper/helper%20main%20screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/common/loginoption/login_option_view.dart';
import 'package:connect_canteen/app/modules/student_modules/student_mainscreen/user_mainScreen.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/vendor_main_Screen/vendr_main_Screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final logincontroller = Get.put(LoginController());
  final storage = GetStorage();
  final groupController = Get.put(GroupController());

  void handleMainScreen() async {
    if (storage.read(userType) == student) {
      await logincontroller.fetchUserData();
      if (logincontroller
          .userDataResponse.value.response!.first.groupid.isNotEmpty) {
        groupController.fetchGroupData();
      }

      logincontroller.userDataResponse.value.response!.isNotEmpty
          ? Get.offAll(() => UserMainScreenView())
          : log("some went wrong");
    } else if (storage.read(userType) == canteenhelper) {
      Get.offAll(() => HelperMainScreen());
    } else {
      Get.offAll(() => CanteenMainScreenView());
    }
  }

  @override
  void initState() {
    super.initState();
    listenToNotifications();
    log(" this is the user type ${storage.read(userType)}");

    Timer(const Duration(seconds: 1), () {
      logincontroller.autoLogin()
          ? handleMainScreen()
          : Get.offAll(() => LoginOptionView());
    });
  }

//  to listen to any notification clicked or not
  listenToNotifications() {
    log("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      log("This is the notification evet " + event);
    });
  }

//-------------
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 254, 254),
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
    );
  }
}
