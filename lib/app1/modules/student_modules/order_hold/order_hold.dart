 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile_simmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class OrderHoldPage extends StatelessWidget {
  final studentOrderControler = Get.put(StudetnORderController());
  final String cid;
  final String schoolrefrenceId;
  OrderHoldPage({super.key, required this.cid, required this.schoolrefrenceId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                'Orders Holds',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<OrderResponse>>(
        stream: studentOrderControler.fetchHoldOrders(cid, schoolrefrenceId),
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
            final students = snapshot.data!;

            return Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  OrderResponse order = students[index]!;
              
                  return Column(
                    children: [
                      Padding(
                        padding: AppPadding.screenHorizontalPadding,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            // margin: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.productName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20.0.sp,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'NPR ${order.price}',
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
                                            '${order.mealtime}',
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
                                            '${order.customer}',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 0.6.h),
                                      if (order.orderType == 'hold')
                                        Row(
                                          children: [
                                            Text("Hold on:"),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              '${order.holdDate}',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Text(
                                              '${order.quantity}/plate',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[600],
                                              ),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: 14.h,
                                      height: 14.h,
                                      child: CachedNetworkImage(
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Opacity(
                                          opacity: 0.8,
                                          child: Shimmer.fromColors(
                                            baseColor: const Color.fromARGB(
                                                255, 248, 246, 246),
                                            highlightColor: Color.fromARGB(
                                                255, 238, 230, 230),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color.fromARGB(
                                                    255, 243, 242, 242),
                                              ),
                                              width: 14.h,
                                              height: 14.h,
                                            ),
                                          ),
                                        ),
                                        imageUrl: order.productImage ?? '',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          radius: 21.4.sp,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                              255, 224, 218, 218),
                                        ),
                                      ),
                                    ),
                   
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
              ),
            );
          }
        },
      ),
    );
  }
}
