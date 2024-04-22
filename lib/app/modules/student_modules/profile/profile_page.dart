import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/group/view/group.dart';
import 'package:connect_canteen/app/modules/student_modules/orders/orders_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/order_history/view/order_hisory_page.dart';
import 'package:connect_canteen/app/modules/student_modules/profile/my_profile/my_profile.dart';
import 'package:connect_canteen/app/modules/student_modules/profile/order_holds_view.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/widget/profile_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatelessWidget {
  final logincontroller = Get.put(LoginController());
  final orderController = Get.put(OrderController());
  final groupController = Get.put(GroupController());
  Future<void> refreshData() async {
    logincontroller.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => refreshData(),
        child: Obx(() {
          if (logincontroller.isFetchLoading.value) {
            return const LoadingWidget();
          } else {
            return Column(children: [
              Container(
                color: Color(0xff06C167),
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h, bottom: 3.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        logincontroller
                            .userDataResponse.value.response!.first.name,
                        style: AppStyles.mainHeading,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => MyProfile(),
                              transition: Transition.rightToLeft,
                              duration: duration);
                        },
                        child: Container(
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
                            radius: 25.sp,
                            backgroundColor: Colors.white,
                            child: CachedNetworkImage(
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Opacity(
                                opacity: 0.8,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.black12,
                                  highlightColor: Colors.red,
                                  child: Container(),
                                ),
                              ),
                              imageUrl: logincontroller.userDataResponse.value
                                      .response!.first.profilePicture ??
                                  '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape:
                                      BoxShape.circle, // Apply circular shape
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
                                backgroundColor:
                                    const Color.fromARGB(255, 224, 218, 218),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => Container(
                    height: 15.h,
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Grey color with transparency
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 222, 219, 219)
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      logincontroller.userDataResponse.value
                                          .response!.first.studentScore
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Student Score',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Adjust height or add child widget as needed
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            child: Container(
                              // Container 2
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 222, 219, 219)
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    logincontroller.userDataResponse.value
                                        .response!.first.fineAmount
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Fine Amount',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            child: Container(
                              // Container 3
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 222, 219, 219)
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    logincontroller.userDataResponse.value
                                        .response!.first.miCoin
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'miCoins',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 2.h,
              ),
              Divider(
                height: 0.7.h,
                thickness: 0.7.h,
                color: Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
              ),
              ProfileTile(
                onTap: () {
                  Get.to(() => MyProfile(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Profile",
                leadingIcon: const Icon(Icons.person),
              ),
              ProfileTile(
                onTap: () {
                  groupController.fetchGroupData().then((value) {
                    Get.to(() => GroupPage(),
                        transition: Transition.rightToLeft, duration: duration);
                  });
                },
                title: "Groups",
                leadingIcon: const Icon(Icons.group),
              ),
              ProfileTile(
                onTap: () {
                  Get.to(() => OrderHistoryPage(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Order History",
                leadingIcon: const Icon(Icons.shopping_cart_checkout_sharp),
              ),
              ProfileTile(
                onTap: () {
                  orderController.calenderDate.value = '';
                  orderController.fetchHoldOrders();
                  Get.to(() => OrderHoldsView(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Order Holds ",
                leadingIcon: const Icon(Icons.stop_circle_outlined),
              ),
              ProfileTile(
                onTap: () {
                  // Get.to(() => AboutUsPage(),
                  //     transition: Transition.rightToLeft, duration: duration);
                },
                title: "About Us",
                leadingIcon: const Icon(Icons.attach_money),
              ),
              ProfileTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        isbutton: true,
                        heading: 'Alert',
                        subheading: "Do you want to logout of the application?",
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
            ]);
          }
        }),
      ),
    );
  }
}
