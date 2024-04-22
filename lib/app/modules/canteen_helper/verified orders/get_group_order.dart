import 'dart:developer';

import 'package:connect_canteen/app/modules/canteen_helper/verified%20orders/verify_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/pin_entry.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:connect_canteen/app/widget/no_data_widget.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_checkout/veodor_order_controller.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class GetGrouOrder extends StatelessWidget {
  final verifyController = Get.put(VerifyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Order Checkout',
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                flex: 9,
                child: Obx(() {
                  if (verifyController.checkoutLoading.value) {
                    return const LoadingWidget();
                  } else {
                    if (verifyController.isOrderFetch.value) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 10.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: ScrollPhysics(),
                                itemCount: verifyController
                                    .orderResponse.value.response!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.w),
                                      child: Container(
                                        height: 10.h,
                                        width: 10.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: verifyController
                                                    .orderResponse
                                                    .value
                                                    .response![index]
                                                    .customerImage ??
                                                '',
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) => Icon(
                                                    Icons.error_outline,
                                                    size: 40),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            const Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Color.fromARGB(221, 93, 90, 90),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: verifyController
                                  .orderResponse.value.response!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 2.0.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();

                                      // Show the dialog when the button is pressed
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              // Set rectangle shape to remove curved edges
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 0,

                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize
                                                  .min, // Set to min to adjust height to content
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w),
                                                  child: Container(
                                                    height: 10.h,
                                                    width: 10.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl: verifyController
                                                                .orderResponse
                                                                .value
                                                                .response![
                                                                    index]
                                                                .customerImage ??
                                                            '',
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                                Icons
                                                                    .error_outline,
                                                                size: 40),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Text(
                                                  'Checkout By : ${verifyController.orderResponse.value.response![index].customer}',
                                                  style:
                                                      AppStyles.listTileTitle,
                                                ),
                                              ],
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal:
                                                    24), // Adjust padding as needed
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  verifyController
                                                      .checkoutOrder()
                                                      .then((value) {
                                                    Get.back();

                                                    showDialog(
                                                        barrierColor:
                                                            Color.fromARGB(255,
                                                                    73, 72, 72)
                                                                .withOpacity(
                                                                    0.5),
                                                        context: Get.context!,
                                                        builder: (BuildContext
                                                            context) {
                                                          return CustomPopup(
                                                            message:
                                                                'Succesfully "Checkout"',
                                                            onBack: () {
                                                              Get.back();
                                                            },
                                                          );
                                                        });
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  padding: EdgeInsets.all(12.0),
                                                  child: const Text(
                                                    "Checkout",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // Background color of the container
                                        borderRadius: BorderRadius.circular(
                                            10), // Border radius if needed
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 202, 200, 200)
                                                .withOpacity(
                                                    0.5), // Shadow color
                                            spreadRadius: 5, // Spread radius
                                            blurRadius: 7, // Blur radius
                                            offset: Offset(0, 3), // Offset
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                color: Colors
                                                    .white, // Add a background color
                                              ),
                                              height: 16.h,
                                              width: 30.w,
                                              child: ClipRRect(
                                                // Use ClipRRect to ensure that the curved corners are applied
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                child: CachedNetworkImage(
                                                  imageUrl: verifyController
                                                          .orderResponse
                                                          .value
                                                          .response![index]
                                                          .productImage ??
                                                      '',
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url,
                                                          error) =>
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
                                                  verifyController
                                                      .orderResponse
                                                      .value
                                                      .response![index]
                                                      .productName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      AppStyles.listTileTitle,
                                                ),
                                                Text(
                                                  'Rs.${verifyController.orderResponse.value.response![index].price.toStringAsFixed(2)}',
                                                  style: AppStyles
                                                      .listTilesubTitle,
                                                ),
                                                Text(
                                                    '${verifyController.orderResponse.value.response![index].customer}',
                                                    style: AppStyles
                                                        .listTilesubTitle),
                                                Text(
                                                  '${verifyController.orderResponse.value.response![index].date}' +
                                                      '(${verifyController.orderResponse.value.response![index].mealtime})',
                                                  style: AppStyles
                                                      .listTilesubTitle,
                                                ),
                                                Text(
                                                  '${verifyController.orderResponse.value.response![index].quantity}-plate',
                                                  style: AppStyles
                                                      .listTilesubTitle,
                                                ),
                                                SizedBox(
                                                  height: 0.4.h,
                                                ),
                                                verifyController
                                                                .orderResponse
                                                                .value
                                                                .response![
                                                                    index]
                                                                .holdDate !=
                                                            '' ||
                                                        verifyController
                                                            .orderResponse
                                                            .value
                                                            .response![index]
                                                            .holdDate
                                                            .isNotEmpty
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.green,
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      0.1.h,
                                                                  horizontal:
                                                                      2.w),
                                                          child: Text(
                                                              "Hold:${verifyController.orderResponse.value.response![index].holdDate}",
                                                              style: AppStyles
                                                                  .listTilesubTitle),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromARGB(
                                                              255,
                                                              216,
                                                              188,
                                                              27),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      0.1.h,
                                                                  horizontal:
                                                                      2.w),
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
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return NoDataWidget(
                          message: "There is no Order",
                          iconData: Icons.error_outline);
                    }
                  }
                })),
          ],
        ),
      ),
    );
  }
}
