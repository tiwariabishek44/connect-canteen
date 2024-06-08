import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/menue_section.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentHomePage extends StatelessWidget {
  final storage = GetStorage();
  final loignController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    log(" this is the user id fetch from staroage ::::::" +
        storage.read(userId));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 1.0.h,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 3.h,
              ),
              _buildProfileCard(context),
              SizedBox(
                height: 2.h,
              ),
              BalanceCard(userid: storage.read(userId)),
              SizedBox(
                height: 3.h,
              ),
              Text(
                'What do you want to eat today? 🍔',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 80, 79, 79),
                ),
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

          return Container(
            width: 100.w,
            height: 14.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 237, 234, 234),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(179, 60, 58, 58),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Added this line
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${studetnData.name}! 👋',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 70, 69, 69),
                              ),
                            ),
                            Text(
                              studetnData.classes == ''
                                  ? 'N/A'
                                  : '${studetnData.classes}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(179, 50, 49, 49),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 21.sp,
                        backgroundColor: Colors.white,
                        child: studetnData.profilePicture == ''
                            ? CircleAvatar(
                                radius: 21.sp,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              )
                            : CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                imageUrl: studetnData.profilePicture,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
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
