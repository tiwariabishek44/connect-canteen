import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/listtile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile_simmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HistoryTab extends StatelessWidget {
  final studentOrderControler = Get.put(StudetnORderController());
  final String groupcod;
  final String schoolrefrenceId;
  HistoryTab(
      {super.key, required this.groupcod, required this.schoolrefrenceId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderResponse>>(
      stream: studentOrderControler.fetchHistory(groupcod, schoolrefrenceId),
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
          final snapShotOrders = snapshot.data!;

          List<OrderResponse> allOrders = snapShotOrders;

          // Group orders by date
          Map<String, List<OrderResponse>> groupedOrders = {};
          allOrders.forEach((order) {
            String date = order.date; // Assuming date is a string
            if (!groupedOrders.containsKey(date)) {
              groupedOrders[date] = [];
            }
            groupedOrders[date]!.add(order);
          });

          // Extract unique dates and sort them
          List<String> dates = groupedOrders.keys.toList();
          dates.sort((a, b) => b.compareTo(a));

          return Padding(
            padding: EdgeInsets.only(top: 1.0.h),
            child: ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                String date = dates[index];
                List<OrderResponse> orders = groupedOrders[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, left: 5.w),
                      child: Text(
                        date,
                        style: TextStyle(
                            fontSize: 17.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                    // Order items
                    ...orders.map((order) => buildItemWidget(order)).toList(),
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
            ),
          );
        }
      },
    );
  }

  Widget buildItemWidget(OrderResponse item) {
    return OrderTiles(
      order: item,
      type: 'history',
    );
  }
}
