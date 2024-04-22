import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:flutter/material.dart';

import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/clase_wise_order/class_wise_order_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/student_fine/fine_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/student_fine/student_information.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/pin_entry.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClassWiseOrder extends StatelessWidget {
  final String classs;

  ClassWiseOrder({
    Key? key,
    required this.classs,
  }) : super(key: key);

  Future<void> refreshData() async {}
  final ordercontroller = Get.put(ClassWiseOrderController());
  final fineController = Get.put(StudnetFineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        title: Text(
          classs,
          style: AppStyles.appbar,
        ),
      ),
      body: Obx(() {
        if (ordercontroller.isloading.value)
          return LoadingScreen();
        else {
          if (ordercontroller.orderResponse.value.response == null ||
              ordercontroller.orderResponse.value.response!.isEmpty) {
            // Show an empty cart page if there are no orders available
            return EmptyCartPage(
              onClick: () {},
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: AppPadding.screenHorizontalPadding,
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          ordercontroller.orderResponse.value.response!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.0.h),
                          child: GestureDetector(
                            onTap: () {
                              fineController.fineApply.value = false;
                              fineController.fetchUserData(ordercontroller
                                  .orderResponse.value.response![index].cid);

                              Get.to(() => StudnetInformationPage(
                                    order: ordercontroller
                                        .orderResponse.value.response![index],
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the container
                                borderRadius: BorderRadius.circular(
                                    10), // Border radius if needed
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 202, 200, 200)
                                            .withOpacity(0.5), // Shadow color
                                    spreadRadius: 5, // Spread radius
                                    blurRadius: 7, // Blur radius
                                    offset: Offset(0, 3), // Offset
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors
                                          .white, // Add a background color
                                    ),
                                    height: 20.h,
                                    width: 30.w,
                                    child: ClipRRect(
                                      // Use ClipRRect to ensure that the curved corners are applied
                                      borderRadius: BorderRadius.circular(7),
                                      child: CachedNetworkImage(
                                        imageUrl: ordercontroller
                                                .orderResponse
                                                .value
                                                .response![index]
                                                .productImage ??
                                            '',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error_outline, size: 40),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ordercontroller.orderResponse.value
                                            .response![index].productName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.listTilesubTitle,
                                      ),
                                      Text(
                                        'Rs.${ordercontroller.orderResponse.value.response![index].price.toStringAsFixed(2)}',
                                        style: AppStyles.listTilesubTitle,
                                      ),
                                      Text(
                                          '${ordercontroller.orderResponse.value.response![index].customer}',
                                          style: AppStyles.listTilesubTitle),
                                      Text(
                                        '${ordercontroller.orderResponse.value.response![index].date}' +
                                            '(${ordercontroller.orderResponse.value.response![index].mealtime})',
                                        style: AppStyles.listTilesubTitle,
                                      ),
                                      Text(
                                        '${ordercontroller.orderResponse.value.response![index].quantity}-plate',
                                        style: AppStyles.listTilesubTitle,
                                      ),
                                      SizedBox(
                                        height: 0.4.h,
                                      ),
                                      ordercontroller
                                                      .orderResponse
                                                      .value
                                                      .response![index]
                                                      .holdDate !=
                                                  '' ||
                                              ordercontroller
                                                  .orderResponse
                                                  .value
                                                  .response![index]
                                                  .holdDate
                                                  .isNotEmpty
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.green,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.1.h,
                                                    horizontal: 2.w),
                                                child: Text(
                                                    "Hold:${ordercontroller.orderResponse.value.response![index].holdDate}",
                                                    style: AppStyles
                                                        .listTilesubTitle),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color.fromARGB(
                                                    255, 216, 188, 27),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.1.h,
                                                    horizontal: 2.w),
                                                child: Text(
                                                  "Regular",
                                                  style: AppStyles
                                                      .listTilesubTitle,
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }),
    );
  }
}
