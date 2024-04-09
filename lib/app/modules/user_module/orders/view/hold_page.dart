import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HoldPage extends StatelessWidget {
  final OrderResponse order;
  HoldPage({super.key, required this.order});

  final orderContorller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    DateTime orderHoldTime = DateFormat('HH:mm').parse(order.orderHoldTime);

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentTime);
    orderHoldTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      orderHoldTime.hour,
      orderHoldTime.minute,
    );

    // Check if current time is after order hold time
    bool timePassed = currentTime.isAfter(orderHoldTime);

    return Scaffold(
        appBar: AppBar(
          title: Text('Order Hold '),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.greyColor,
              width: double.infinity,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 3.5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Hold",
                      style: TextStyle(
                        fontSize: 23.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "You have the option to place your order on hold, allowing you to use it the next day.",
                      style: AppStyles.listTileTitle,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          "You can hold order till: ",
                          style: AppStyles.topicsHeading,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          order.orderHoldTime,
                          style: AppStyles.titleStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "You won't get your cash Back",
                      style: AppStyles.titleStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Order",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 15.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                          height: 15.h,
                          width: 30.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: CachedNetworkImage(
                              imageUrl: order.productImage ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline, size: 40),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.listTileTitle),
                            Text('Rs.${order.price.toStringAsFixed(2)}',
                                style: AppStyles.listTileTitle),
                            Text(order.customer,
                                style: AppStyles.listTilesubTitle),
                            Text('${order.date}  (${order.mealtime})',
                                style: AppStyles.listTilesubTitle),
                            Text('${order.quantity}-plate',
                                style: AppStyles.listTilesubTitle),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  timePassed &&
                          (order.date ==
                              DateFormat('dd/MM/yyyy\'', 'en')
                                  .format(nepaliDateTime))
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "You can't hold the order as time has passed.",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : CustomButton(
                          text: 'Hold',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialog(
                                  isbutton: true,
                                  heading: 'Hold Order',
                                  subheading:
                                      "Be sure this meal will not be prepared in the canteen.",
                                  firstbutton: "Agree",
                                  secondbutton: 'Cancel',
                                  onConfirm: () {
                                    orderContorller.holdUserOrder(
                                        context, order.id, order.date);
                                    // Perform actions when the user agrees
                                  },
                                );
                              },
                            );
                          },
                          isLoading: false,
                        )
                ],
              ),
            ),
          ],
        ));
  }
}
