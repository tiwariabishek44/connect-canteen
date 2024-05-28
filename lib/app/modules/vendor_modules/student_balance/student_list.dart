import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/wallet/page.dart';
import 'package:connect_canteen/app/modules/vendor_modules/student_balance/student_balance_controlller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentList extends StatelessWidget {
  StudentList({super.key});
  final studentBalanceController = Get.put(StudentBalanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: "Student Balance"),
      body: Obx(() {
        if (studentBalanceController.fetchLoading.value) {
          return const LoadingWidget();
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ListView.builder(
              itemCount: studentBalanceController
                  .friendListResponse.value.response!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                        () => WalletPage(
                              isStudent: false,
                              userId: studentBalanceController
                                  .friendListResponse
                                  .value
                                  .response![index]
                                  .userid,
                              name: studentBalanceController.friendListResponse
                                  .value.response![index].name,
                              image: studentBalanceController.friendListResponse
                                  .value.response![index].profilePicture,
                            ),
                        transition: Transition.rightToLeft,
                        duration: duration);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: ListTile(
                        leading: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 22.sp,
                                backgroundColor: Colors.white,
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircleAvatar(
                                    radius: 21.4.sp,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                        255, 224, 218, 218),
                                  ),
                                  imageUrl: studentBalanceController
                                          .friendListResponse
                                          .value
                                          .response![index]
                                          .profilePicture ??
                                      '',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape
                                          .circle, // Apply circular shape
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    radius: 21.4.sp,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                        255, 224, 218, 218),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                            '${studentBalanceController.friendListResponse.value.response![index].name}'),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
