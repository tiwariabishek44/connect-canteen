import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/product_detials_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/utils/order_tile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/canteen_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RemaningOrderSection extends StatelessWidget {
  final String date;
  RemaningOrderSection({super.key, required this.date});  
  final canteenDailyReport = Get.put(CanteenReportController());

  @override
  Widget build(BuildContext context) {
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
              "Remaning Orders",
              style: AppStyles.topicsHeading,
            ),
          ),
          StreamBuilder<List<OrderResponse>>(
            stream: canteenDailyReport.getallUncheckoutOrder(date),
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
                          'No Order Remaning',
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
              canteenDailyReport.calculateUncheckoutOrder(orders);

              return Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: canteenDailyReport.uncheckoutOrderDetails.length,
                    itemBuilder: (context, index) {
                      String productName = canteenDailyReport
                          .uncheckoutOrderDetails.keys
                          .toList()[index];
                      ProductDetail detail = canteenDailyReport
                          .uncheckoutOrderDetails[productName]!;

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
                                Text(detail.productName,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  " ${detail.totalQuantity}-plate",
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
