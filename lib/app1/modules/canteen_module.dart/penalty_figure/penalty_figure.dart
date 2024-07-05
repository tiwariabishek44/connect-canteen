import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/utils/order_tile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/penalty_figure/penalty_figure_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class PenaltyFigurePage extends StatelessWidget {
  PenaltyFigurePage({super.key});
  final penaltyController = Get.put(PenaltyFigureController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.backgroundColor,
            titleSpacing: 4.0, // Adjusts the spacing above the title
            title: Text(
              'Orders',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0.w),
                  child: Text(
                    'Un Checked Orders',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
          ),
          body: StreamBuilder<List<OrderResponse>>(
            stream: penaltyController.getAllOrder(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      CanteenOrderTilesShrimmer();
                    });
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No orders found'));
              }

              var orders = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
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
                                              'Qnty: ${order.quantity}',
                                              style: TextStyle(
                                                fontSize: 18.0.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            Icon(Icons.alarm_outlined,
                                                size: 17.sp),
                                            SizedBox(width: 1.w),
                                            Text(
                                              '(${order.mealtime})',
                                              style: TextStyle(
                                                fontSize: 17.0.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 0.6.h),
                                        Row(
                                          children: [
                                            Icon(Icons.person_outline,
                                                size: 17.sp),
                                            SizedBox(width: 1.w),
                                            Text(
                                              '${order.customer}',
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 0.6.h),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_month_outlined,
                                                size: 17.sp),
                                            SizedBox(width: 1.w),
                                            Text(
                                              '${order.date}',
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 9.h,
                                    height: 9.h,
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
                                            width: 9.h,
                                            height: 9.h,
                                          ),
                                        ),
                                      ),
                                      imageUrl: order.productImage ?? '',
                                      imageBuilder: (context, imageProvider) =>
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
