import 'dart:async';
import 'dart:developer';

import 'package:connect_canteen/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/common/loginoption/login_option_view.dart';
import 'package:connect_canteen/app/modules/user_module/student_mainscreen/user_mainScreen.dart';
import 'package:connect_canteen/app/modules/user_module/group/group_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/vendor_main_Screen/vendr_main_Screen.dart';

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
    } else {
      Get.offAll(() => CanteenMainScreenView());
      // final res = await vendorProfileController.getVendorData();
      // final dashobardResponse =
      //     await vendorDashboardController.getVendorDashboard();
      // IF PROFILE DATA IS FETCHED SUCCESSFULLY THEN GO TO VENDOR MAIN SCREEN
      // res && dashobardResponse
      //     ? Get.offAll(() => VendorMainScreenView())
      //     : CustomDialog(
      //         title: 'Something Went Wrong',
      //         content: const Text("Please try again later"),
      //         onPressed: () {
      //           Get.back();
      //         },
      //         successButtonText: "Ok",
      //       );
    }
  }

  @override
  void initState() {
    super.initState();
    listenToNotifications();

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
              'assets/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
