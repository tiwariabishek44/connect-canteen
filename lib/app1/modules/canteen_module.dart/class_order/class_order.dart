import 'dart:developer';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/class_order/canteen_order_tile.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/class_order/class_order_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile_simmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClassOrder extends StatelessWidget {
  final String grade;
  ClassOrder({super.key, required this.grade});
  final classOrderController = Get.put(ClassOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          "Orders",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                grade,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<UserOrderResponse>>(
        stream: classOrderController.fetchOrders(
            grade, "texasinternationalcollege"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return OrderTilesShrimmer();
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt,
                      size: 70,
                      color: const Color.fromARGB(255, 197, 196, 196)),
                  SizedBox(height: 2.h),
                  Text('No orders yet',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Text(
                        'You\'ll be able to see your order history and reorder your favourites here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          } else {
            final orders = snapshot.data!;
            log("Orders: ${orders.length}");

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                UserOrderResponse order = orders[index]!;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CanteenORderTile(
                    order: order,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
