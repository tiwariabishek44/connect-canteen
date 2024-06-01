import 'dart:developer';

import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile_simmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllOrdersTab extends StatelessWidget {
  final studentOrderControler = Get.put(StudetnORderController());
  final String groupcod;
  final String schoolrefrenceId;
  AllOrdersTab(
      {super.key, required this.groupcod, required this.schoolrefrenceId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderResponse>>(
      stream: studentOrderControler.fetchOrders(groupcod, schoolrefrenceId),
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
                    size: 70, color: const Color.fromARGB(255, 197, 196, 196)),
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

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              OrderResponse order = orders[index]!;

              return Column(
                children: [
                  OrderTiles(
                    order: order,
                    type: 'regular',
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: Color.fromARGB(255, 232, 230, 230),
                  )
                ],
              );
            },
          );
        }
      },
    );
  }
}
