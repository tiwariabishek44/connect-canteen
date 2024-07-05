import 'dart:async';
import 'dart:developer';

import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/mealTime/meal_time_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/cart_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/time_off.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/custom_snack.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final mealTimeController = Get.put(MealTimeController());
  void checkTime(String timeString, String mealtime, String restriction) {
    DateTime now = DateTime.now();
    DateTime specifiedTime = DateFormat.Hm().parse(timeString);

    // Set today's date for comparison
    specifiedTime = DateTime(
        now.year, now.month, now.day, specifiedTime.hour, specifiedTime.minute);
    if (restriction == 'true') {
      if (now.isAfter(specifiedTime)) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return CustomAlertDialog(timeString: timeString);
          },
        );
      } else {
        cartController.mealtime.value = mealtime;
      }
    } else {
      cartController.mealtime.value = mealtime;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    return Scaffold(
      backgroundColor: Color(0xffF5F6FB),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xffffffff),
        title: Text('Cart'),
      ),
      body: Obx(() {
        if (cartController.isFetching.value) {
          return LoadingWidget();
        } else {
          if (cartController.cartItems.isEmpty) {
            return Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Color.fromARGB(255, 37, 39, 37),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Add items to your cart to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4.h, bottom: 4.0.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartController.cartItems.length,
                          itemBuilder: (context, index) {
                            var item = cartController.cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 15.5.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Rs.${item.price}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Column(
                                        children: [
                                          Container(
                                            height: 4.h,
                                            width: 29.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xffD4A4AC),
                                              ),
                                              color: Color(0xffFFF6F7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 15.sp,
                                                  ),
                                                  onPressed: () {
                                                    if (item.quantity > 1) {
                                                      cartController
                                                          .updateQuantity(
                                                              item,
                                                              item.quantity -
                                                                  1);
                                                    } else {
                                                      cartController.removeItem(
                                                          item.id, context);
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  '${item.quantity}',
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 15.sp,
                                                  ),
                                                  onPressed: () {
                                                    cartController
                                                        .updateQuantity(item,
                                                            item.quantity + 1);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Text(
                                              'Rs.${item.price * item.quantity}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            // Padding(
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Select Meal Time",
                                  style: AppStyles.titleStyle,
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 3.5,
                                  ),
                                  itemCount: cartController.mealTime.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        checkTime(
                                            cartController
                                                .mealTime[index].finalOrderTime,
                                            cartController
                                                .mealTime[index].mealTime,
                                            cartController
                                                .mealTime[index].restriction);
                                      },
                                      child: Obx(() => Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 166, 167, 167),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: cartController
                                                          .mealtime.value ==
                                                      cartController
                                                          .mealTime[index]
                                                          .mealTime
                                                  ? Color.fromARGB(255, 0, 0, 0)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                cartController
                                                    .mealTime[index].mealTime,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: cartController
                                                              .mealtime.value ==
                                                          cartController
                                                              .mealTime[index]
                                                              .mealTime
                                                      ? Color.fromARGB(
                                                          255, 255, 255, 255)
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.0.h, bottom: 8.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(todayDate,
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Mealtime',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(cartController.mealtime.value,
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      '\Rs ${cartController.totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }
      }),
      bottomNavigationBar: Obx(() => cartController.cartItems.isEmpty
          ? SizedBox.shrink()
          : Container(
              color: Colors.white,
              height: 10.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => CustomButton(
                      isLoading: cartController.orderLoading.value,
                      text: 'Order Now',
                      onPressed: () {
                        log('thisis the meal time ${cartController.mealtime.value}');
                        FocusScope.of(context).unfocus();
                        if (cartController.mealtime.value == 'NA') {
                          cartController.orderLoading.value = true;
                          Timer(Duration(milliseconds: 200), () {
                            cartController.orderLoading.value = false;
                            CustomSnackbar.error(
                                context, 'Please Select MealTime');
                          });
                          return;
                        } else {
                          cartController.makeOrder(cartController.totalPrice,
                              cartController.cartItems);
                        }

                        // Add your order logic here
                      },
                      buttonColor: Color(0xffF04F5F),
                      textColor: Colors.white,
                    )),
              ),
            )),
    );
  }
}
