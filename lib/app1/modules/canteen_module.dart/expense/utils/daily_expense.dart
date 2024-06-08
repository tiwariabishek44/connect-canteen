import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/salse_figure_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DailyExpense extends StatelessWidget {
  DailyExpense({super.key});

  final salsefigureController = Get.put(SalseFigureController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderResponse>>(
        stream: salsefigureController.getAllOrder(''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                    offset: Offset(0,
                        2), // Adjust the values to control the shadow appearance
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 197, 195, 195)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 1.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Rs 00.0",
                              style: AppStyles.topicsHeading,
                            ),
                            Text(
                              'Gross Sales',
                              style: AppStyles.listTilesubTitle,
                            ),
                            // Add spacing between the texts
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 197, 195, 195)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 1.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Rs. woo",
                              style: AppStyles.topicsHeading,
                            ),
                            Text(
                              'Net Sales',
                              style: AppStyles.listTilesubTitle,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 245, 255, 255),
                    Color.fromARGB(255, 200, 232, 200)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(66, 109, 109, 109),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today Expense',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(179, 60, 58, 58),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\NPR 00.0',
                    style: TextStyle(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 17, 17, 17),
                    ),
                  ),
                ],
              ),
            );
          }

          var orders = snapshot.data!;
          salsefigureController.calculateTotals(orders);
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 245, 255, 255),
                  Color.fromARGB(255, 200, 232, 200)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(66, 109, 109, 109),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today Expense',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(179, 60, 58, 58),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '\NPR ${salsefigureController.grandTotal.value.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 17, 17, 17),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
