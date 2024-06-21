import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/checkout_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/utils/order_tile_shrimmer.dart';
import 'package:connect_canteen/app1/widget/black_textform_field.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:connect_canteen/app1/widget/no_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class OrderCheckoutPage extends StatefulWidget {
  final String groupCode;

  OrderCheckoutPage({required this.groupCode});

  @override
  _OrderCheckoutPageState createState() => _OrderCheckoutPageState();
}

class _OrderCheckoutPageState extends State<OrderCheckoutPage> {
  final checkoutController = Get.put(CheckoutController());
  bool selectAll = true;

  @override
  void initState() {
    super.initState();
    checkoutController.selectAll.value = true;
  }

  // void toggleSelectAll() {
  //   setState(() {
  //     selectAll = !selectAll;
  //     checkoutController.selectAll.value = selectAll;
  //     for (var order in checkoutController.orders) {
  //       checkoutController.selectedOrders[order.id] = selectAll;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            title: Text(' Orders Checkout'),
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.black,
            //       ),
            //       child: TextButton(
            //         onPressed: toggleSelectAll,
            //         child: Text(
            //           selectAll ? 'Unselect All' : 'Select All',
            //           style: TextStyle(
            //             color: const Color.fromARGB(255, 255, 255, 255),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
          ),
          body: StreamBuilder<List<OrderResponse>>(
            stream: checkoutController.getAllGroupOrder(widget.groupCode),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return CanteenOrderTilesShrimmer();
                  },
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return NoOrder(onClick: () {});
              }

              var orders = snapshot.data!;
              checkoutController.orders = orders;

              // Initialize all orders as selected when the data is loaded
              if (checkoutController.selectAll.value) {
                for (var order in orders) {
                  checkoutController.selectedOrders[order.id] = true;
                }
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 16.0,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.productName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20.0.sp,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Qnty: ${order.quantity}',
                                            style: TextStyle(
                                              fontSize: 18.0.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          Icon(Icons.alarm_outlined,
                                              size: 17.sp),
                                          SizedBox(width: 1.w),
                                          Text(
                                            '(${order.mealtime})',
                                            style: TextStyle(
                                              fontSize: 17.0.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 0.6.h),
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline,
                                              size: 17.sp),
                                          SizedBox(width: 1.w),
                                          Text(
                                            '${order.customer}',
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Rs .${(order.price).toInt()}',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 8, 120, 23),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        checkoutController
                                                .selectedOrders[order.id] =
                                            !(checkoutController
                                                    .selectedOrders[order.id] ??
                                                false);
                                      },
                                      child: Container(
                                        width: 9.h,
                                        height: 9.h,
                                        child: CachedNetworkImage(
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Opacity(
                                            opacity: 0.8,
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 248, 246, 246),
                                              highlightColor: Color.fromARGB(
                                                  255, 238, 230, 230),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: const Color.fromARGB(
                                                      255, 243, 242, 242),
                                                ),
                                                width: 9.h,
                                                height: 9.h,
                                              ),
                                            ),
                                          ),
                                          imageUrl: order.customerImage ?? '',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                            radius: 21.4.sp,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 224, 218, 218),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(() => Checkbox(
                                      value: checkoutController
                                              .selectedOrders[order.id] ??
                                          false,
                                      onChanged: (bool? value) {
                                        checkoutController
                                                .selectedOrders[order.id] =
                                            value ?? false;
                                      },
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  )
                ],
              );
            },
          ),
          floatingActionButton: Container(
            width: 200, // Set the desired width here
            child: FloatingActionButton(
              onPressed: () {
                var selectedOrderIds = checkoutController.selectedOrders.keys
                    .where((id) => checkoutController.selectedOrders[id]!)
                    .toList();

                if (selectedOrderIds.isEmpty) {
                  CustomSnackbar.error(context, "Please Select Orders");
                } else {
                  checkoutController.checkoutSelectedOrders(selectedOrderIds);
                }
              },
              backgroundColor: Colors.black,
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 19.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 50.h,
          left: 40.w,
          child: Obx(() => checkoutController.checkoutLoading.value
              ? LoadingWidget()
              : SizedBox.shrink()),
        )
      ],
    );
  }
}
