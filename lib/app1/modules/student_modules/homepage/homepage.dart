import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/cart_page.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/category.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/menue_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentHomePage extends StatelessWidget {
  final storage = GetStorage();
  final loignController = Get.put(LoginController());
  final transctionController = Get.put(TransctionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F6FB),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              _buildProfileCard(context),
              SizedBox(
                height: 2.h,
              ),

              // make container with the screen widht and the light grey border

              SizedBox(
                height: 2.h,
              ),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 211, 210, 210),
                      thickness: 1,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "What's on your mind ?",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 80, 79, 79),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 211, 210, 210),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),

              HorizontalGridView(),
              SizedBox(
                height: 2.h,
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "What do you want to eat today ?",
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w400),
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
          StudentDataResponse studetnData = snapshot.data!;
          log("${loignController.studentDataResponse.value!.classes}");

          return Column(
            children: [
              // row to show the Column( name and the class)  and the circular avatar for the cart .
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studetnData.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 80, 79, 79),
                          ),
                        ),
                        Text(
                          studetnData.classes,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 80, 79, 79),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(CartPage(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Color.fromARGB(255, 80, 79, 79),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: double.infinity,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Color.fromARGB(255, 228, 224, 224),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            transctionController.showMoney.value
                                ? '\NPR ${NumberFormat('#,##,###').format(studetnData.balance)}'
                                : 'NPR XX.XX',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 119, 117, 117),
                            ),
                          )),
                      Obx(() => GestureDetector(
                            onTap: () {
                              transctionController.showMoney.value =
                                  !transctionController.showMoney.value;
                            },
                            child: Icon(
                              transctionController.showMoney.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
