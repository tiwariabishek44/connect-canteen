import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/chekcout_page.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/wallet/wallet_page.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/acount_info.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/menue_section.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentHomePage extends StatelessWidget {
  final storage = GetStorage();
  final loignController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0.0.h,
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              _buildProfileCard(context),
              SizedBox(
                height: 2.h,
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(
                      () => WalletPage(
                        grade:
                            loignController.studentDataResponse.value!.classes,
                        userId:
                            loignController.studentDataResponse.value!.userid,
                        isStudent: true,
                        name: loignController.studentDataResponse.value!.name,
                        image: loignController
                            .studentDataResponse.value!.profilePicture,
                      ),
                      transition: Transition.cupertinoDialog,
                    );
                  },
                  child: BalanceCard(userid: storage.read(userId))),
              SizedBox(
                height: 3.h,
              ),
              Text(
                'What do you want to eat today? 🍔',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 80, 79, 79),
                ),
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
              MenueSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return StreamBuilder<StudentDataResponse?>(
      stream: loignController.getStudetnData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return SizedBox.shrink();
        } else if (snapshot.data == null) {
          return SizedBox.shrink();
        } else {
          StudentDataResponse studentData = snapshot.data!;

          return Container(
            width: 100.w,
            height: 14.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 226, 226, 226),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${studentData.name}! 👋',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: Color.fromARGB(255, 70, 69, 69),
                              ),
                            ),
                            Text(
                              studentData.classes.isEmpty
                                  ? 'N/A'
                                  : '${studentData.classes}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(179, 50, 49, 49),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Replace CircleAvatar with Row for icons
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.notifications),
                              onPressed: () {
                                Get.to(() => OrderCheckoutPage(
                                    groupCode: loignController
                                        .studentDataResponse.value!.groupcod));
                                // Handle notifications button press
                                // Example: Get.toNamed('/notifications');
                              },
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          // CircleAvatar(
                          //   backgroundColor: Colors.white,
                          //   child: IconButton(
                          //     icon: Icon(Icons.group),
                          //     onPressed: () {
                          //       Get.to(() => GroupPage(),
                          //           transition: Transition.cupertinoDialog);
                          //       // Handle notifications button press
                          //       // Example: Get.toNamed('/notifications');
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class DetailPageController extends GetxController {
  var quantity = 1.obs;

  void increment() => quantity++;
  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
