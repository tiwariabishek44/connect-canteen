import 'package:connect_canteen/app1/modules/common/login/view/login_view.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingScreen extends StatelessWidget {
  final loginOptionController = Get.put(LoginOptionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70.h,
              child: Image.asset(
                'assets/onboarding.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 60.h, // Adjust as necessary to overlap the image slightly
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Welcome  to connect canteen !",
                    style: AppStyles.listTileTitle.copyWith(fontSize: 23.sp),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Make Dining Easy",
                    style: AppStyles.listTileTitle
                        .copyWith(fontSize: 20.sp, color: Colors.grey[500]),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector( 
                    onTap: () {
                      loginOptionController.isStudent.value = true;

                      Get.to(() => LoginView());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "As Student",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      loginOptionController.isStudent.value = false;

                      Get.to(() => LoginView());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "As Canteen ",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
