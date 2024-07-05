import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/utils/otp_generator.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class OrderTiles extends StatefulWidget {
  final UserOrderResponse order;
  final String type;
  OrderTiles({super.key, required this.order, required this.type});

  @override
  _OrderTilesState createState() => _OrderTilesState();
}

class _OrderTilesState extends State<OrderTiles> {
  final loginController = Get.put(LoginController());
  final orderController = Get.put(StudetnORderController());
  bool isExpanded = false;
  final otpController = Get.put(OTPGenerator());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontalPadding,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: isExpanded
              ? Border.all(color: Colors.blueAccent, width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.order.status == 'uncompleted'
                          ? GestureDetector(
                              onTap: () {
                                otpController.isotpshow.value =
                                    !otpController.isotpshow.value;
                              },
                              child: Obx(() => Text(
                                    otpController.isotpshow.value
                                        ? 'Otp: ${widget.order.otp}'
                                        : 'Otp:  XXXX',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0.sp,
                                    ),
                                  )),
                            )
                          : Text(
                              widget.order.date,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20.0.sp,
                              ),
                            ),
                      Row(
                        children: [
                          Text(
                            'NPR ${widget.order.totalAmount}',
                            style: TextStyle(
                                fontSize: 16.0.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Icon(
                            Icons.alarm_outlined,
                            size: 17.sp,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '${widget.order.mealTime}',
                            style: TextStyle(
                                fontSize: 16.0.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 17.sp,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '${widget.order.username}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.6.h),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.order.status == 'completed'
                                ? 'Order Complete'
                                : 'Order Processing',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              color: widget.order.status == 'completed'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
            if (isExpanded) ...[
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  final product = widget.order.products[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0.sp,
                              ),
                            ),
                            Text(
                              'Quantity: ${product.quantity}',
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'NPR ${product.price}',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
