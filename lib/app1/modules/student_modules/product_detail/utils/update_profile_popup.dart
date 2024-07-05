import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/login/view/profilepicture.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/acount_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showUpdateProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // No border radius
        ),
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Update Your Profile ',
          style: AppStyles.appbar,
        ),
        content: Text('Please update your profile Picture to continue.'),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "    Ok   ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
