import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/product_detials_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/mealTime/meal_time_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/utils/order_tile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement_controller.dart';
import 'package:connect_canteen/app1/widget/no_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class OrderRequirementPage extends StatefulWidget {
  OrderRequirementPage({super.key});

  @override
  State<OrderRequirementPage> createState() => _OrderRequirementPageState();
}

class _OrderRequirementPageState extends State<OrderRequirementPage> {
  final orderRequiremtnController = Get.put(OrderRequirementController());
  final mealtimeControllre = Get.put(MealTimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'Orders ',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Today Requirement ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          //
          Container(
              height: 6.h, // Set the desired height for the horizontal ListView
              child: StreamBuilder<List<MealTime>>(
                stream: mealtimeControllre
                    .getAllMealTimes('texasinternationalcollege'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MealTime> mealTimes = snapshot.data!;

                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: mealTimes.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    orderRequiremtnController.mealtime.value =
                                        'All';
                                  });
                                },
                                child: Obx(() => Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: orderRequiremtnController
                                                    .mealtime.value ==
                                                'All'
                                            ? Color.fromARGB(255, 9, 9, 9)
                                            : const Color.fromARGB(
                                                255, 247, 245, 245),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'All',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: orderRequiremtnController
                                                          .mealtime.value ==
                                                      'All'
                                                  ? AppColors.backgroundColor
                                                  : Color.fromARGB(
                                                      255, 84, 82, 82)),
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    orderRequiremtnController.mealtime.value =
                                        mealTimes[index - 1].mealTime;
                                  });
                                },
                                child: Obx(() => Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: orderRequiremtnController
                                                    .mealtime.value ==
                                                mealTimes[index - 1].mealTime
                                            ? Color.fromARGB(255, 9, 9, 9)
                                            : const Color.fromARGB(
                                                255, 247, 245, 245),
                                      ),
                                      child: Center(
                                        child: Text(
                                          mealTimes[index - 1].mealTime,
                                          style: TextStyle(
                                              fontSize: 18.0.sp,
                                              color: orderRequiremtnController
                                                          .mealtime.value ==
                                                      mealTimes[index - 1]
                                                          .mealTime
                                                  ? AppColors.backgroundColor
                                                  : Color.fromARGB(
                                                      255, 84, 82, 82)),
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          }
                        });
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )),
          SizedBox(
            height: 4.h,
          ),
          Expanded(
            child: StreamBuilder<List<OrderResponse>>(
              stream: orderRequiremtnController.getAllTodayOrders(),
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
                  return NoOrder(
                    onClick: () {},
                  );
                }

                var orders = snapshot.data!;
                orderRequiremtnController.calculateProductTotals(orders);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            orderRequiremtnController.productDetails.length,
                        itemBuilder: (context, index) {
                          String productName = orderRequiremtnController
                              .productDetails.keys
                              .toList()[index];
                          ProductDetail detail = orderRequiremtnController
                              .productDetails[productName]!;

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
                                            detail.productName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 19.0.sp,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Qnty: ${detail.totalQuantity}',
                                                style: TextStyle(
                                                  fontSize: 19.0.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   width: 9.h,
                                    //   height: 9.h,
                                    //   child: CachedNetworkImage(
                                    //     progressIndicatorBuilder:
                                    //         (context, url, downloadProgress) =>
                                    //             Opacity(
                                    //       opacity: 0.8,
                                    //       child: Shimmer.fromColors(
                                    //         baseColor: const Color.fromARGB(
                                    //             255, 248, 246, 246),
                                    //         highlightColor: Color.fromARGB(
                                    //             255, 238, 230, 230),
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(20),
                                    //             color: const Color.fromARGB(
                                    //                 255, 243, 242, 242),
                                    //           ),
                                    //           width: 9.h,
                                    //           height: 9.h,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     imageUrl: detail.productImage ?? '',
                                    //     imageBuilder:
                                    //         (context, imageProvider) =>
                                    //             Container(
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(20),
                                    //         image: DecorationImage(
                                    //           image: imageProvider,
                                    //           fit: BoxFit.cover,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     fit: BoxFit.fill,
                                    //     width: double.infinity,
                                    //     errorWidget: (context, url, error) =>
                                    //         CircleAvatar(
                                    //       radius: 21.4.sp,
                                    //       child: Icon(
                                    //         Icons.person,
                                    //         color: Colors.white,
                                    //       ),
                                    //       backgroundColor: const Color.fromARGB(
                                    //           255, 224, 218, 218),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
