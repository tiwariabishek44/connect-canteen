import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/widget/logout_cornfiration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HelperSetting extends StatelessWidget {
  final loignController = Get.put(LoginController());

  Widget buildCustomListTile({
    required String title,
    required String subtitle,
    required IconData trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 19.sp, color: Colors.black),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: Colors.grey[700]),
      ),
      trailing: Icon(
        trailing,
        color: Colors.grey[700],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0.w, // Adjusts the spacing above the title
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w400),
        ),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'System Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              buildCustomListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogoutConfirmationDialog(
                          isbutton: true,
                          heading: 'Alert',
                          subheading:
                              "Do you want to logout of the application?",
                          firstbutton: "Yes",
                          secondbutton: 'No',
                          onConfirm: () {
                            loignController.logout();
                          },
                        );
                      },
                    );
                  },
                  title: 'LogOut',
                  subtitle: 'Get out from system',
                  trailing: Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
