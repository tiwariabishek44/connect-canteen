import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/widget/profile_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HelperProfilePage extends StatelessWidget {
  final logincontroller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Column(children: [
            Container(
              color: Color(0xff06C167),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 6.h, right: 2.w, left: 2.w, bottom: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Canteen Helper",
                        maxLines: 3,
                        style: AppStyles.mainHeading,
                      ),
                    ),
                    Container(
                      height: 35.sp,
                      width: 35.sp,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage('assets/person.png'),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: Column(
                children: [
                  ProfileTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                            isbutton: true,
                            heading: 'Alert',
                            subheading:
                                "Do you want to logout of the application?",
                            firstbutton: "Yes",
                            secondbutton: 'No',
                            onConfirm: () {
                              logincontroller.logout();
                            },
                          );
                        },
                      );
                    },
                    title: "Logout",
                    leadingIcon: const Icon(
                      Icons.logout,
                    ),
                  )
                ],
              ),
            )
          ]),
          logincontroller.isloading.value
              ? LoadingWidget()
              : const SizedBox.shrink()
        ],
      )),
    );
  }
}
