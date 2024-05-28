import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';

import 'package:connect_canteen/app/modules/vendor_modules/order_requirement_reports/view/order_requirement_report_view.dart';
import 'package:connect_canteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/view/order_hold_list.dart';
import 'package:connect_canteen/app/modules/vendor_modules/student_balance/student_balance_controlller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/student_balance/student_list.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/widget/profile_tile.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingView extends StatelessWidget {
  final logincontroller = Get.put(LoginController());
  final orderContorller = Get.put(CanteenHoldOrders());
  final orderRequestController = Get.put(OrderRequirementContoller());
  final salseContorlller = Get.put(SalsesController());
  final studentbalanceController = Get.put(StudentBalanceController());
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

    salseContorlller.calenderDate.value == formattedDate;
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
                        "Canteen Manager",
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
                      salseContorlller.calenderDate.value = formattedDate;
                      salseContorlller.fetchTotalOrder().then((value) {
                        salseContorlller.fetchTotalSales();
                        orderContorller.fetchDailyHold('All', formattedDate);
                        orderRequestController
                            .fetchMeal(0, formattedDate)
                            .then((value) {
                          Get.to(() => CanteenReport(),
                              transition: Transition.rightToLeft,
                              duration: duration);
                        });
                      });

                      // // Handle click for Analytics\
                    },
                    title: "Canteen Report",
                    leadingIcon: const Icon(Icons.trending_up),
                  ),

                  ProfileTile(
                    onTap: () {
                      studentbalanceController.fetchStudents().then((value) =>
                          Get.to(() => StudentList(),
                              transition: Transition.rightToLeft,
                              duration: duration));
                    },
                    title: "Student Balance",
                    leadingIcon: const Icon(Icons.money),
                  ),
                  // ProfileTile(
                  //   onTap: () async {
                  //     await orderContorller.fetchHoldOrders();
                  //     Get.to(() => OrderHoldListView(),
                  //         transition: Transition.rightToLeft,
                  //         duration: duration);
                  //   },
                  //   title: "Order Holds Records",
                  //   leadingIcon: const Icon(Icons.stop_circle_outlined),
                  // ),
                  // ProfileTile(
                  //   onTap: () {
                  //     final List<OrderResponse> orders =
                  //         testcontorller.generateDummyOrders();

                  //     printController.uploadOrders(orders);
                  //   },
                  //   title: "About Us",
                  //   leadingIcon: const Icon(Icons.attach_money),
                  // ),
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
