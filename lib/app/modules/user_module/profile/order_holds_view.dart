import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHoldsView extends StatelessWidget {
  OrderHoldsView({
    Key? key,
  }) : super(key: key);
  final logincontroller = Get.put(LoginController());

  final orderContorller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: '',
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    Text(
                      "You won't get your cash Back",
                      style: AppStyles.titleStyle,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            logincontroller.userDataResponse.value.response!.first.fineAmount !=
                    0
                ? Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100], // Background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning, // Icon for warning
                          color: Colors.red, // Warning color
                          size: 40.0, // Icon size
                        ),
                        SizedBox(width: 16.0), // Spacing between icon and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penalty', // Title
                                style: TextStyle(
                                  fontSize: 20.0, // Title font size
                                  fontWeight:
                                      FontWeight.bold, // Title font weight
                                  color: Colors.red, // Title color
                                ),
                              ),
                              SizedBox(height: 8.0), // Vertical spacing
                              Text(
                                'You have unpaid fines. Please pay the fine to release the orders.', // Message
                                style: TextStyle(
                                  fontSize: 16.0, // Message font size
                                  color: Colors.black, // Message color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 2.h,
            ),
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
                  // Add your ListView here with padding
                  Obx(() {
                    if (orderContorller.holdLoading.value ||
                        orderContorller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
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
                                vertical:
                                    1.h), // Adjust vertical padding as needed
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
                                    height: 17.h,
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
                                          height: 15.h,
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
                                              style: AppStyles.listTileTitle,
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
                                              style: AppStyles.listTileTitle,
                                            ),
                                            Text(
                                              '(${order.orderType}) ${order.holdDate}  ',
                                              style: AppStyles.listTileTitle,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        logincontroller
                                                    .userDataResponse
                                                    .value
                                                    .response!
                                                    .first
                                                    .fineAmount ==
                                                0
                                            ? Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ConfirmationDialog(
                                                          isbutton: true,
                                                          heading:
                                                              'Order Schedule',
                                                          subheading:
                                                              "for ${order.holdDate}",
                                                          firstbutton: "Agree",
                                                          secondbutton:
                                                              'Cancel',
                                                          onConfirm: () {
                                                            orderContorller
                                                                .scheduleHoldOrders(
                                                                    context,
                                                                    order.id,
                                                                    order
                                                                        .holdDate);

                                                            // Perform actions when the user agrees
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w,
                                                              vertical: 0.7.h),
                                                      child: Text(
                                                        "Schedule",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ));
                      }
                    }
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
