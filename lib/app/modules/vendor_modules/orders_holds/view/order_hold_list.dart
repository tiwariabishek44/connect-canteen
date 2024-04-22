import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHoldListView extends StatelessWidget {
  OrderHoldListView({super.key});

  final orderContorller = Get.put(CanteenHoldOrders());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        title: Text(
          'Orders Hold Records',
          style: AppStyles.appbar,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: Obx(() {
                if (orderContorller.holdLoading.value ||
                    orderContorller.isloading.value) {
                  return LoadingWidget();
                } else {
                  if (orderContorller.holdOrderResponse.value.response ==
                          null ||
                      orderContorller
                          .holdOrderResponse.value.response!.isEmpty) {
                    return Center(
                      child: Container(
                        color: AppColors.greyColor,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.0.h, horizontal: 3.5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No orders are in hold",
                                style: AppStyles.titleStyle,
                              ),
                              SizedBox(height: 3.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h), // Adjust vertical padding as needed
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderContorller
                              .holdOrderResponse.value.response!.length,
                          itemBuilder: (context, index) {
                            OrderResponse order = orderContorller
                                .holdOrderResponse.value.response![index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2.0.h),
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
                                          .withOpacity(0.5), // Shadow color
                                      spreadRadius: 5, // Spread radius
                                      blurRadius: 7, // Blur radius
                                      offset: Offset(0, 3), // Offset
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Row(
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
                                          height: 18.h,
                                          width: 30.w,
                                          child: ClipRRect(
                                            // Use ClipRRect to ensure that the curved corners are applied
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  order.productImage ?? '',
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                      Icons.error_outline,
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
                                              order.productName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppStyles.listTileTitle,
                                            ),
                                            Text(
                                              'Rs.${order.price.toStringAsFixed(2)}',
                                              style: AppStyles.listTilesubTitle,
                                            ),
                                            Text(
                                                '${orderContorller.holdOrderResponse.value.response![index].customer}',
                                                style:
                                                    AppStyles.listTilesubTitle),
                                            Text(
                                              '${order.date}  ' +
                                                  '(${order.mealtime})',
                                              style: AppStyles.listTilesubTitle,
                                            ),
                                            Text(
                                              '${order.quantity}-plate',
                                              style: AppStyles.listTilesubTitle,
                                            ),
                                            Text(
                                              '(${order.orderType}) ${order.holdDate}  ',
                                              style: AppStyles.listTilesubTitle,
                                            ),
                                            Text(
                                              'Class:-${order.classs}',
                                              style: AppStyles.listTilesubTitle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ));
                  }
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
