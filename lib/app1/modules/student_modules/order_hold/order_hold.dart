import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/listtile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
        stream: studentOrderControler.fetchOrders(cid, schoolrefrenceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListtileShrimmer();
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

            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                OrderResponse student = students[index]!;

                return ListTile(
                  leading: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor: Colors.white,
                          child: student?.productImage == ''
                              ? CircleAvatar(
                                  radius: 21.4.sp,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 224, 218, 218),
                                )
                              : CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircleAvatar(
                                    radius: 21.4.sp,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                        255, 224, 218, 218),
                                  ),
                                  imageUrl: student?.productImage ?? '',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape
                                          .circle, // Apply circular shape
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
                      ),
                      student?.groupid != ''
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 7.5,
                                backgroundColor: Color.fromARGB(
                                    255, 0, 0, 0), // Adjust color as needed
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 9,
                                ),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                  title: Text(
                    "${student?.productName}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${student?.price}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
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
