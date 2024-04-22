import 'package:connect_canteen/app/modules/vendor_modules/widget/pin_entry.dart';
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

class OrderCheckoutPage extends StatelessWidget {
  final ordercontroller = Get.put(VendorOrderController());
  final bool ischeckout;
  OrderCheckoutPage({super.key, required this.ischeckout});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        scrolledUnderElevation: 0,
        title: Text(
          "Orders ${ischeckout ? 'Checkout' : "Verify"}",
          style: AppStyles.appbar,
        ),
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                if (ordercontroller.isgroup.value)
                  ordercontroller.isgroup.value =
                      !ordercontroller.isgroup.value;
              },
              child: Container(
                padding: EdgeInsets.all(8), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: ordercontroller.isgroup.value
                      ? AppColors.greyColor
                      : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 19.sp,
                  color: ordercontroller.isgroup.value
                      ? AppColors.iconColors
                      : Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w), // Add spacing between icons
          Obx(
            () => GestureDetector(
              onTap: () {
                if (!ordercontroller.isgroup.value)
                  ordercontroller.isgroup.value =
                      !ordercontroller.isgroup.value;
              },
              child: Container(
                padding: EdgeInsets.all(8), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: ordercontroller.isgroup.value
                      ? AppColors.iconColors
                      : Color.fromARGB(255, 206, 201, 201),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people,
                  size: 19.sp,
                  color: ordercontroller.isgroup.value
                      ? AppColors.backgroundColor
                      : const Color.fromARGB(255, 19, 17, 17),
                ),
              ),
            ),
          ),
          SizedBox(width: 5.w), // Add spacing between icons
        ],
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            Container(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ordercontroller.groupCod.value = value;
                  ordercontroller.fetchOrders(value!);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Color.fromARGB(255, 234, 236, 239),
                  filled: true,
                  hintText: 'Group Code',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
                flex: 9,
                child: Obx(() {
                  if (ordercontroller.groupCod.value == '') {
                    return GroupPinEntry();
                  } else if (ordercontroller.checkoutLoading.value) {
                    return LoadingWidget();
                  } else {
                    if (!ordercontroller.isOrderFetch.value) {
                      return NoDataWidget(
                          message: "There is no Order",
                          iconData: Icons.error_outline);
                    } else {
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
                                            imageUrl: ordercontroller
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
                              itemCount: ordercontroller
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
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    ordercontroller
                                                            .isgroup.value
                                                        ? "Group"
                                                        : "Single",
                                                    style:
                                                        AppStyles.mainHeading,
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
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
                                                        imageUrl: ordercontroller
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
                                                  '${ischeckout ? "Checkout" : 'Verify'} By : ${ordercontroller.orderResponse.value.response![index].customer}',
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
                                                  ordercontroller
                                                          .isCheckoutOrder
                                                          .value =
                                                      ischeckout ? true : false;
                                                  ordercontroller
                                                      .checkoutOrder(
                                                    ordercontroller
                                                            .isgroup.value
                                                        ? ordercontroller
                                                            .groupCod.value
                                                        : ordercontroller
                                                            .orderResponse
                                                            .value
                                                            .response![index]
                                                            .id,
                                                  )
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
                                                                'Succesfully ${ischeckout ? "Checkout" : 'Verify'}',
                                                            onBack: () {
                                                              Get.back();
                                                            },
                                                          );
                                                        });
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff06C167),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(
                                                    "${ischeckout ? "Orders Checkout" : 'Verify Orders'}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
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
                                                  imageUrl: ordercontroller
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
                                                  ordercontroller
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
                                                  'Rs.${ordercontroller.orderResponse.value.response![index].price.toStringAsFixed(2)}',
                                                  style: AppStyles
                                                      .listTilesubTitle,
                                                ),
                                                Text(
                                                    '${ordercontroller.orderResponse.value.response![index].customer}',
                                                    style: AppStyles
                                                        .listTileTitle),
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
                    }
                  }
                })),
          ],
        ),
      ),
    );
  }
}
