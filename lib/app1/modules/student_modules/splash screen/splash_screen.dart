import 'dart:async';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../common/login/login_controller.dart';
import '../../common/login/view/login_view.dart';

class SplashScreen extends StatefulWidget {
  final storage = GetStorage();
  SplashScreen({super.key});
  final arguments = Get.arguments;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final loginController = Get.put(LoginController());
  String source = "others";
  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      source = widget.arguments["source"];
    }
    final accessToken = widget.storage.read("token");
    Timer(const Duration(seconds: 1), () {
      accessToken != null || source == "guest"
          ? Get.offAll(() => LoginView())
          : Get.offAll(() => const LoginView());
    });
  }

  //---------------Load Home page data---------------//
  void loadData(var accessToken) async {}

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 3.h,
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
              ),
              const CircularProgressIndicator(
                color: AppColors.primaryColor,
              )
            ],
          )),
        ),
      ),
    );
  }
}
