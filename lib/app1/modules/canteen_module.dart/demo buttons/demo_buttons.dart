import 'package:connect_canteen/app/modules/vendor_modules/order_requirement_reports/view/order_requirement_report_view.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/dashboard/dashboard.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/hold_search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20verify/verify_search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/report_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/wallet_class/class_wallet.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ButtonColumnPage extends StatelessWidget {
  final loginContorller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Button Column Page'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButtonContainer(
                  label: 'logiout  ',
                  color: Colors.red,
                  onTap: () {

                    loginContorller.logout();
                    // Get.to(() => OrderCheckoutSearch(),
                    //     transition: Transition.cupertinoDialog);
                    // print('Button A pressed');
                  },
                ),
                SizedBox(height: 20), // Add spacing between buttons
                buildButtonContainer(
                  label: 'Order Hold ',
                  color: Colors.green,
                  onTap: () {
                    String userId = 'SEECPIJ67PfTQnMiI0G30p9PmU93';
                    // Transactions transaction = Transactions(
                    //   remarks: 'we have    ',
                    //   name: 'Load',
                    //   amount: 100.0,
                    //   date: nepaliDateTime,
                    // );
                    String adminId = 'admin456';
                    String schoolId = 'school789';

                    // walletController.addTransaction(userId, transaction,
                    //     adminId, schoolId, 'class 1', 'Abishek tiwari');
                  },
                ),
                SizedBox(height: 20), // Add spacing between buttons
                buildButtonContainer(
                  label: 'Order Verify',
                  color: Colors.blue,
                  onTap: () {
                    Get.to(() => VerifySearchPage(),
                        transition: Transition.cupertinoDialog);
                    print('Button A pressed');
                  },
                ),
                buildButtonContainer(
                  label: 'Order Requirement ',
                  color: Colors.blue,
                  onTap: () {
                    Get.to(() => OrderRequirementPage(),
                        transition: Transition.cupertinoDialog);
                    print('Button A pressed');
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                buildButtonContainer(
                  label: 'Class Wallet ',
                  color: Colors.blue,
                  onTap: () {
                    Get.to(() => ClassWalletPage(),
                        transition: Transition.cupertinoDialog);
                    print('Button A pressed');
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                buildButtonContainer(
                  label: 'Class Wallet ',
                  color: Colors.blue,
                  onTap: () {
               
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                buildButtonContainer(
                  label: 'Dashboard ',
                  color: Colors.blue,
                  onTap: () {
                    Get.to(() => CanteenDashboard(),
                        transition: Transition.cupertinoDialog);
                    print('Button A pressed');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtonContainer({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
