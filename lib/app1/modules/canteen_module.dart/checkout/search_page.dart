import 'dart:developer';

import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/checkout_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/chekcout_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderCheckoutSearch extends StatelessWidget {
  OrderCheckoutSearch({super.key});
  final checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Order Checkout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Enter the student group code and get the list of the student orders!",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19.sp,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) async {
                    checkoutController.groupCod.value = value;

                    log(" this i the ${checkoutController.groupCod.value.length}");
                    if (checkoutController.groupCod.value.length == 4) {
                      bool hasOrders = await checkoutController
                          .validateAndFetchOrders(value);
                      if (!hasOrders) {
                        ScaffoldMessenger.of(Get.context!)
                            .showSnackBar(const SnackBar(
                          content: Text('No orders found for this group code'),
                        ));
                      } else {
                        // Navigate to the orders page
                        FocusScope.of(context).unfocus();
                        Get.to(() => OrderCheckoutPage(groupCode: value),
                            transition: Transition.cupertinoDialog);
                      }
                      return;
                    }

                    // Fetch and validate orders
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.all(2.h),
                    filled: true,
                    fillColor: const Color.fromARGB(24, 152, 151, 151),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    errorMaxLines: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
