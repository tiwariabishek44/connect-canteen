import 'dart:ffi';

import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_checkout/veodor_order_controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:connect_canteen/app/widget/no_data_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/pin_entry.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class OrderCancel extends StatelessWidget {
  final holdOrderController = Get.put(CanteenHoldOrders());
  final ordercontroller = Get.put(VendorOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        scrolledUnderElevation: 0,
        title: Text(
          "Orders Hold",
          style: AppStyles.appbar,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: AppPadding.screenHorizontalPadding,
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Container(
                    color: Colors.white,
                    child: TextField(
                      onChanged: (value) {
                        ordercontroller.groupCod.value = value;
                        ordercontroller.fetchOrders(value!);
                      },
                      style: TextStyle(fontSize: 16.sp),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xffE8ECF4),
                        filled: true,
                        hintText: 'Group Code',
                        hintStyle: TextStyle(color: Colors.black),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                    flex: 9,
                    child: Obx(() {
                      if (ordercontroller.groupCod.value == '') {
                        return GroupPinEntry();
                      } else {
                        if (!ordercontroller.isOrderFetch.value)
                          return NoDataWidget(
                              message: "There is no Order",
                              iconData: Icons.error_outline);
                        else {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: 10.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: ScrollPhysics(),
                                    itemCount: ordercontroller
                                        .orderResponse.value.response!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.w),
                                          child: Container(
                                            height: 10.h,
                                            width: 10.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: ordercontroller
                                                        .orderResponse
                                                        .value
                                                        .response![index]
                                                        .customerImage ??
                                                    '',
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Icon(Icons.error_outline,
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
                                  itemCount: ordercontroller
                                      .orderResponse.value.response!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 2.0.h),
                                      child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            holdOrderController
                                                .holdUserOrder(
                                                    context,
                                                    ordercontroller
                                                        .orderResponse
                                                        .value
                                                        .response![index]
                                                        .id,
                                                    ordercontroller
                                                        .orderResponse
                                                        .value
                                                        .response![index]
                                                        .date)
                                                .then((value) {
                                              ordercontroller.fetchOrders(
                                                  ordercontroller
                                                      .groupCod.value);

                                              showDialog(
                                                  barrierColor: Color.fromARGB(
                                                          255, 73, 72, 72)
                                                      .withOpacity(0.5),
                                                  context: Get.context!,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomPopup(
                                                      message:
                                                          'Succesfully Hold Order ',
                                                      onBack: () {
                                                        Get.back();
                                                      },
                                                    );
                                                  });
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Background color of the container
                                              borderRadius: BorderRadius.circular(
                                                  10), // Border radius if needed
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                          255, 230, 227, 227)
                                                      .withOpacity(
                                                          0.5), // Shadow color
                                                  spreadRadius:
                                                      5, // Spread radius
                                                  blurRadius: 7, // Blur radius
                                                  offset:
                                                      Offset(0, 3), // Offset
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    color: Colors
                                                        .white, // Add a background color
                                                  ),
                                                  height: 19.h,
                                                  width: 30.w,
                                                  child: ClipRRect(
                                                    // Use ClipRRect to ensure that the curved corners are applied
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    child: CachedNetworkImage(
                                                      imageUrl: ordercontroller
                                                              .orderResponse
                                                              .value
                                                              .response![index]
                                                              .productImage ??
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
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ordercontroller
                                                          .orderResponse
                                                          .value
                                                          .response![index]
                                                          .productName,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppStyles
                                                          .listTileTitle,
                                                    ),
                                                    Text(
                                                      'Rs.${ordercontroller.orderResponse.value.response![index].price.toStringAsFixed(2)}',
                                                      style: AppStyles
                                                          .listTilesubTitle,
                                                    ),
                                                    Text(
                                                        '${ordercontroller.orderResponse.value.response![index].customer}',
                                                        style: AppStyles
                                                            .listTilesubTitle),
                                                    Text(
                                                      '${ordercontroller.orderResponse.value.response![index].date}' +
                                                          '(${ordercontroller.orderResponse.value.response![index].mealtime})',
                                                      style: AppStyles
                                                          .listTilesubTitle,
                                                    ),
                                                    Text(
                                                      '${ordercontroller.orderResponse.value.response![index].quantity}-plate',
                                                      style: AppStyles
                                                          .listTilesubTitle,
                                                    ),
                                                    SizedBox(
                                                      height: 0.4.h,
                                                    ),
                                                    ordercontroller
                                                                    .orderResponse
                                                                    .value
                                                                    .response![
                                                                        index]
                                                                    .holdDate !=
                                                                '' ||
                                                            ordercontroller
                                                                .orderResponse
                                                                .value
                                                                .response![
                                                                    index]
                                                                .holdDate
                                                                .isNotEmpty
                                                        ? Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0.1.h,
                                                                      horizontal:
                                                                          2.w),
                                                              child: Text(
                                                                  "Hold:${ordercontroller.orderResponse.value.response![index].holdDate}",
                                                                  style: AppStyles
                                                                      .listTilesubTitle),
                                                            ),
                                                          )
                                                        : Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Color
                                                                  .fromARGB(
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
                                          )),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    })),
              ],
            ),
          ),
          Obx(() => holdOrderController.holdLoading.value
              ? Positioned(child: LoadingWidget())
              : Container())
        ],
      ),
    );
  }
}
