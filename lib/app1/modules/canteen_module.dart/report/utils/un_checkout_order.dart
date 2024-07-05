import 'dart:developer';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:connect_canteen/app1/model/product_detials_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/canteen_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RemaningORders extends StatelessWidget {
  final String date;
  RemaningORders({super.key, required this.date});
  final canteenDailyReport = Get.put(CanteenReportController());

  @override
  Widget build(BuildContext context) {
    log(" the date is $date");
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 250, 249, 249),
            Color.fromARGB(255, 250, 249, 249),
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
          Padding(
            padding: EdgeInsets.only(left: 3.0.w, top: 2.h),
            child: Text(
              "Remaning Order",
              style: AppStyles.topicsHeading,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          //dividre
          Divider(
            color: const Color.fromARGB(255, 209, 206, 206),
            thickness: 1,
          ),
          SizedBox(
            height: 2.h,
          ),
          StreamBuilder<List<UserOrderResponse>>(
            stream: canteenDailyReport.getRemaningOrder(date),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 5.h,
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: AppColors.shrimmerColorText,
                                    child: Text('thisiproduct',
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: AppColors.shrimmerColorText,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Container(
                                    color: AppColors.shrimmerColorText,
                                    child: Text(" slsllsls",
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                AppColors.shrimmerColorText)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.h),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Order Left',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              var orders = snapshot.data!;
              Map<String, int> aggregatedQuantities =
                  aggregateProductQuantities(orders);
              return Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: aggregatedQuantities.length,
                    itemBuilder: (context, index) {
                      String productName =
                          aggregatedQuantities.keys.toList()[index];
                      int totalQuantity = aggregatedQuantities[productName]!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 5.h,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(productName,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400)),
                                Text(
                                  "${totalQuantity} -plate",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                          255, 151, 16, 7)),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
