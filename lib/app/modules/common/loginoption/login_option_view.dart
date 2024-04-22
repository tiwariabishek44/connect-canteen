import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/modules/common/login/login_page.dart';
import 'package:connect_canteen/app/modules/common/loginoption/login_option_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/vendor_main_Screen/vendr_main_Screen.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginOptionView extends StatelessWidget {
  final loginOptionController = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        iconrequired: false,
        title: '',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              child: Image.asset(
                'assets/splash1.png',
                fit: BoxFit.cover,
              ),
              height: 30.h,
              width: 100.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 2.h),
              child: Column(
                children: [
                  Text(
                    'Continue as:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomButton(
                      text: 'Continue As Student',
                      onPressed: () {
                        loginOptionController.isUser.value = true;
                        Get.to(() => LoginScreen(),
                            transition: Transition.rightToLeft);
                      },
                      isLoading: false),
                  SizedBox(height: 0.6.h),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 97, 96, 96),
                          height: 0.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 97, 96, 96),
                          height: 0.5,
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                      text: 'Continue As Canteen',
                      onPressed: () {
                        loginOptionController.isUser.value = false;
                        Get.to(() => LoginScreen(),
                            transition: Transition.rightToLeft);
                      },
                      isLoading: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
