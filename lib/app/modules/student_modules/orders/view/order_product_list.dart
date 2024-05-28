import 'dart:developer';

import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/student_modules/orders/orders_controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/home/product_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/orders/view/hold_page.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPRoductList extends StatelessWidget {
  final logincontroller = Get.put(LoginController());

  final orderController = Get.put(OrderController());

  Future<void> _refreshData() async {
    await orderController.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orderController.isLoading.value) {
        return LoadingWidget();
      } else {
        if (orderController.orderLoded.value) {
          try {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderController.orderResponse.value.response!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 1.0.h),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (orderController
                                  .orderResponse.value.response![index].cid ==
                              logincontroller.userDataResponse.value.response!
                                  .first.userid) {
                            // Get.to(
                            //     () => HoldPage(
                            //           order: orderController
                            //               .orderResponse.value.response![index],
                            //         ),
                            //     transition: Transition.rightToLeft,
                            //     duration: duration);
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the container
                                borderRadius: BorderRadius.circular(
                                    10), // Border radius if needed
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 230, 227, 227)
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 5, // Spread radius
                                    blurRadius: 7, // Blur radius
                                    offset: Offset(0, 3), // Offset
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors
                                            .white, // Add a background color
                                      ),
                                      height: 15.h,
                                      width: 30.w,
                                      child: ClipRRect(
                                        // Use ClipRRect to ensure that the curved corners are applied
                                        borderRadius: BorderRadius.circular(7),
                                        child: CachedNetworkImage(
                                          imageUrl: orderController
                                                  .orderResponse
                                                  .value
                                                  .response![index]
                                                  .productImage ??
                                              '',
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error_outline,
                                                  size: 40),
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
                                          orderController.orderResponse.value
                                              .response![index].productName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.listTilesubTitle,
                                        ),
                                        Text(
                                          'Rs.${orderController.orderResponse.value.response![index].price.toStringAsFixed(2)}',
                                          style: AppStyles.listTilesubTitle,
                                        ),
                                        Text(
                                            '${orderController.orderResponse.value.response![index].customer}',
                                            style: AppStyles.listTilesubTitle),
                                        Text(
                                          '${orderController.orderResponse.value.response![index].date}  ' +
                                              '(${orderController.orderResponse.value.response![index].mealtime})',
                                          style: AppStyles.listTilesubTitle,
                                        ),
                                        Text(
                                          '${orderController.orderResponse.value.response![index].quantity}-plate',
                                          style: AppStyles.listTilesubTitle,
                                        ),
                                        SizedBox(
                                          height: 0.3.h,
                                        ),
                                        // orderController
                                        //                 .orderResponse
                                        //                 .value
                                        //                 .response![index]
                                        //                 .holdDate !=
                                        //             '' ||
                                        //         orderController
                                        //             .orderResponse
                                        //             .value
                                        //             .response![index]
                                        //             .holdDate
                                        //             .isNotEmpty
                                        //     ? Container(
                                        //         decoration: BoxDecoration(
                                        //           borderRadius:
                                        //               BorderRadius.circular(5),
                                        //           color: Colors.green,
                                        //         ),
                                        //         child: Padding(
                                        //           padding: EdgeInsets.symmetric(
                                        //               vertical: 0.1.h,
                                        //               horizontal: 2.w),
                                        //           child: Text(
                                        //               "Hold:${orderController.orderResponse.value.response![index].holdDate}",
                                        //               style: AppStyles
                                        //                   .listTilesubTitle),
                                        //         ),
                                        //       )
                                        //     : Container(
                                        //         decoration: BoxDecoration(
                                        //           borderRadius:
                                        //               BorderRadius.circular(5),
                                        //           color: Colors.transparent,
                                        //         ),
                                        //         child: Padding(
                                        //           padding: EdgeInsets.symmetric(
                                        //               vertical: 0.1.h,
                                        //               horizontal: 2.w),
                                        //           child: Text(
                                        //             "Regular",
                                        //             style: AppStyles
                                        //                 .listTilesubTitle,
                                        //           ),
                                        //         ),
                                        //       )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          height: 5.h,
                          width: 5.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: orderController.orderResponse.value
                                      .response![index].customerImage ??
                                  '',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline, size: 40),
                            ),
                          ),
                        ),
                      )

                      // Display the more options icon only if the order belongs to the logged-in user
                    ],
                  ),
                );
              },
            );
          } catch (e) {
            return Container();
          }
        } else {
          return EmptyCartPage(
            onClick: () {
              _refreshData();
            },
          );
        }
      }
    });
  }
}
