 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/common/wallet/page.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/group/view/group.dart';
import 'package:connect_canteen/app/modules/student_modules/order_history/order_history_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/orders/orders_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/order_history/view/order_hisory_page.dart';
import 'package:connect_canteen/app/modules/student_modules/profile/order_holds_view.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:connect_canteen/app/widget/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/widget/profile_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ProfilePage extends StatelessWidget {
  final logincontroller = Get.put(LoginController());
  final orderController = Get.put(OrderController());
  final groupController = Get.put(GroupController());
  Future<void> refreshData() async {
    logincontroller.fetchUserData();
  }

  final historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => refreshData(),
        child: Obx(() {
          if (logincontroller.isFetchLoading.value) {
            return const NoDataWidget(
                message: "Loading User Data", iconData: Icons.download);
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: AppPadding.screenHorizontalPadding,
                child: Column(children: [
                  Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 6.h, bottom: 3.h, right: 4.w, left: 4.w),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                logincontroller.fetchUserData();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              255, 204, 202, 202)
                                          .withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(
                                    1), // Adjust padding as needed
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.refresh),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
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
                                    radius: 31.sp,
                                    backgroundColor: Colors.white,
                                    child: CachedNetworkImage(
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Opacity(
                                        opacity: 0.8,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.black12,
                                          highlightColor: Colors.red,
                                          child: Container(),
                                        ),
                                      ),
                                      imageUrl: logincontroller
                                              .userDataResponse
                                              .value
                                              .response!
                                              .first
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
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    logincontroller.userDataResponse.value
                                        .response!.first.name,
                                    style: AppStyles.listTileTitle,
                                  ),
                                  Text(
                                    logincontroller.userDataResponse.value
                                        .response!.first.classes,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 78, 78, 78)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.phone,
                                  color: Color.fromARGB(255, 78, 78, 78)),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                logincontroller.userDataResponse.value.response!
                                    .first.phone,
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 78, 78, 78)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.email,
                                  color: Color.fromARGB(255, 78, 78, 78)),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                logincontroller.userDataResponse.value.response!
                                    .first.email,
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 78, 78, 78)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0.4.h,
                    thickness: 0.4.h,
                    color: Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ProfileTile(
                    onTap: () {
                      Get.to(
                          () => WalletPage(
                                isStudent: true,
                                userId: logincontroller.userDataResponse.value
                                    .response!.first.userid,
                                name: logincontroller.userDataResponse.value
                                    .response!.first.name,
                                image: logincontroller.userDataResponse.value
                                    .response!.first.profilePicture,
                              ),
                          transition: Transition.rightToLeft,
                          duration: duration);
                    },
                    title: "Profile",
                    leadingIcon: const Icon(Icons.person),
                  ),
                  ProfileTile(
                    onTap: () {
                      groupController.fetchGroupData().then((value) {
                        Get.to(() => GroupPage(),
                            transition: Transition.rightToLeft,
                            duration: duration);
                      });
                    },
                    title: "Groups",
                    leadingIcon: const Icon(Icons.group),
                  ),
                  ProfileTile(
                    onTap: () {
                      historyController.fetchGroupHistoryOrders().then((value) {
                        Get.to(() => OrderHistoryPage(),
                            transition: Transition.rightToLeft,
                            duration: duration);
                      });
                    },
                    title: "Order History",
                    leadingIcon: const Icon(Icons.shopping_cart_checkout_sharp),
                  ),
                  ProfileTile(
                    onTap: () {
                      orderController.calenderDate.value = '';
                      orderController.fetchHoldOrders().then((value) {
                        Get.to(() => OrderHoldsView(),
                            transition: Transition.rightToLeft,
                            duration: duration);
                      });
                    },
                    title: "Order Holds ",
                    leadingIcon: const Icon(Icons.stop_circle_outlined),
                  ),
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
                ]),
              ),
            );
          }
        }),
      ),
    );
  }

  static int calculateTimeRemaining(int targetHour) {
    // Get the current time in the Nepali time zone
    var nepalTimeZone = tz.getLocation('Asia/Kathmandu'); // Nepali time zone
    var now = tz.TZDateTime.now(nepalTimeZone);

    // Define the target hour (22:00 or 10 PM)

    // Calculate the difference in hours between now and the target hour
    int hoursRemaining;
    if (now.hour < targetHour) {
      hoursRemaining = targetHour - now.hour;
    } else {
      hoursRemaining = (24 - now.hour) + targetHour;
    }

    return hoursRemaining;
  }

  Widget _buildWalletItem(
      {required String title, required String value, required Color color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                Text(
                  "Rs." + value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
