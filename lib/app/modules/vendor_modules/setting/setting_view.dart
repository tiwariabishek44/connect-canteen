import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';

import 'package:connect_canteen/app/modules/vendor_modules/order_requirement_reports/view/order_requirement_report_view.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/view/order_hold_list.dart';
import 'package:connect_canteen/app/modules/vendor_modules/sales_report/view/sales_report_view.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/widget/profile_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingView extends StatelessWidget {
  final logincontroller = Get.put(LoginController());
  final orderContorller = Get.put(CanteenHoldOrders());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Stack(
          children: [
            Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 7.h),
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
              const SizedBox(
                height: 20,
              ),
              ProfileTile(
                onTap: () {
                  Get.to(() => OrderRequirementReport(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Orders Requirement Report",
                leadingIcon: const Icon(Icons.trending_up),
              ),
              ProfileTile(
                onTap: () {
                  Get.to(() => SalseReportView(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Sales Report ",
                leadingIcon: const Icon(Icons.description),
              ),
              ProfileTile(
                onTap: () async {
                  await orderContorller.fetchHoldOrders();
                  Get.to(() => OrderHoldListView(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Order Holds Records",
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
            ]),
            logincontroller.isloading.value
                ? LoadingWidget()
                : const SizedBox.shrink()
          ],
        ),
      )),
    );
  }
}
