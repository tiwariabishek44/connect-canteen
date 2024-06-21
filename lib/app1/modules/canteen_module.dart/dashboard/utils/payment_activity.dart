import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/dashboard/utils/clickable_action_icon.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/statements/statement_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/statements/statements_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/wallet_class/class_wallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentActivity extends StatelessWidget {
  final String date;
  PaymentActivity({super.key, required this.date});
  final statementController = Get.put(StatementController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(
            10.0), // Adjust the value for the desired curve
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 189, 187, 187).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(
                0, 2), // Adjust the values to control the shadow appearance
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Payment Activity",
                style: AppStyles.topicsHeading,
              )),
          SizedBox(
            height: 1.h,
          ),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 0.93,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            physics: NeverScrollableScrollPhysics(),
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => ClassWalletPage(),
                      transition: Transition.cupertinoDialog);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Color.fromARGB(255, 225, 222, 222)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/wallet.jpg',
                        scale: 14,
                      ),
                      const SizedBox(height: 1.0),
                      Center(
                        child: Text(
                          'Load Wallet',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color.fromARGB(255, 59, 57, 57),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              buildClickableIcon(
                icon: Icons.leaderboard,
                label: 'Statements',
                onTap: () {
                  statementController.selectedDate.value = date;
                  Get.to(() => StatementPage(),
                      transition: Transition.cupertinoDialog);
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
