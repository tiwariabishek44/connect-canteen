import 'package:connect_canteen/app/modules/vendor_modules/daily_report/widget/reaming_order.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DailyReport extends StatelessWidget {
  final orderRequestController = Get.put(OrderRequirementContoller());
  final salesController = Get.put(SalsesController());
  final orderholdController = Get.put(CanteenHoldOrders());
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      appBar: CustomAppBar(
        title: formattedDate,
        iconrequired: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 2.h, left: 9),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Daily Report",
                  style: AppStyles.mainHeading,
                ),
              ),
            ),
            Container(
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
                      child: Obx(() => Container(
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
                                    "Rs. " +
                                        salesController
                                            .totalorderGRandTotal.value
                                            .toInt()
                                            .toString(),
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
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Obx(() => Container(
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
                                    "Rs. " +
                                        salesController.grandTotal.value
                                            .toInt()
                                            .toString(),
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
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.0.w, top: 2.h),
                    child: Text(
                      "Order Requirement",
                      style: AppStyles.topicsHeading,
                    ),
                  ),
                  Obx(() {
                    if (orderRequestController.orderRequirementLoded.value) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount:
                              orderRequestController.productQuantities.length,
                          itemBuilder: (context, index) {
                            final productQuantity =
                                orderRequestController.productQuantities[index];
                            return Container(
                              height: 5.h,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 2.0.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      productQuantity.productName,
                                      style: AppStyles.listTilesubTitle,
                                    ),
                                    Text(
                                      "  ${productQuantity.totalQuantity}-plate",
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 151, 16, 7)),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Order Requirement',
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
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.0.w, top: 2.h),
                    child: Text(
                      "Sales Report",
                      style: AppStyles.topicsHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Obx(
                          () {
                            if (salesController.isLoading.value) {
                              return LoadingWidget();
                            } else {
                              if (salesController
                                  .productWithQuantity.value.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 7.h),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'No sales till now.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: salesController
                                        .productWithQuantity.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 5.h,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${salesController.productWithQuantity[index].productName}',
                                                style:
                                                    AppStyles.listTilesubTitle,
                                              ),
                                              Text(
                                                '${salesController.productWithQuantity[index].totalQuantity} -Plate',
                                                style: TextStyle(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color.fromARGB(
                                                        255, 151, 16, 7)),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            ReamingOrder(),
            SizedBox(
              height: 2.h,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppColors.backgroundColor,
            //     borderRadius: BorderRadius.circular(
            //         10.0), // Adjust the value for the desired curve
            //     boxShadow: [
            //       BoxShadow(
            //         color: Color.fromARGB(255, 189, 187, 187).withOpacity(0.5),
            //         spreadRadius: 1,
            //         blurRadius: 5,
            //         offset: Offset(0,
            //             2), // Adjust the values to control the shadow appearance
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.only(left: 3.0.w, top: 2.h),
            //         child: Text(
            //           "Daily Order Hold",
            //           style: AppStyles.topicsHeading,
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(12.0),
            //         child: Column(
            //           children: [
            //             Obx(
            //               () {
            //                 if (orderholdController.isloading.value) {
            //                   return LoadingWidget();
            //                 } else {
            //                   if (orderholdController.holdOrderReportResponse
            //                               .value.response ==
            //                           null ||
            //                       orderholdController.holdOrderReportResponse
            //                           .value.response!.isEmpty) {
            //                     return Center(
            //                       child: Padding(
            //                         padding:
            //                             EdgeInsets.symmetric(vertical: 7.h),
            //                         child: Column(
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                           children: [
            //                             Text(
            //                               'No OrderHold Today',
            //                               style: TextStyle(
            //                                 color: Colors.grey,
            //                                 fontSize: 20.0,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     );
            //                   } else {
            //                     return ListView.builder(
            //                         shrinkWrap: true,
            //                         physics: ScrollPhysics(),
            //                         itemCount: orderholdController
            //                             .productQuantities.length,
            //                         itemBuilder: (context, index) {
            //                           return Container(
            //                             height: 5.h,
            //                             width: double.infinity,
            //                             child: Padding(
            //                               padding: EdgeInsets.symmetric(
            //                                   horizontal: 2.0.w),
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   Text(
            //                                     '${orderholdController.productQuantities[index].productName}',
            //                                     style:
            //                                         AppStyles.listTilesubTitle,
            //                                   ),
            //                                   Text(
            //                                     '${orderholdController.productQuantities[index].totalQuantity} -Plate',
            //                                     style:
            //                                         AppStyles.listTilesubTitle,
            //                                   )
            //                                 ],
            //                               ),
            //                             ),
            //                           );
            //                         });
            //                   }
            //                 }
            //               },
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 4.h,
            )
          ],
        ),
      )),
    );
  }
}
