import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
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
      backgroundColor: Color(0xffF5F6FB),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xffF5F6FB),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            //
            Container(
                height:
                    6.h, // Set the desired height for the horizontal ListView
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                fontSize: 16.0.sp,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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

            Expanded(
              child: StreamBuilder<List<UserOrderResponse>>(
                stream: orderRequiremtnController.getAllTodayOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return CanteenOrderTilesShrimmer();
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return NoOrder(
                      onClick: () {},
                    );
                  }

                  var orders = snapshot.data!;
                  Map<String, int> aggregatedQuantities =
                      aggregateProductQuantities(orders);

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: aggregatedQuantities.length,
                          itemBuilder: (context, index) {
                            String productName =
                                aggregatedQuantities.keys.toList()[index];
                            int totalQuantity =
                                aggregatedQuantities[productName]!;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 16.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 231, 232, 235),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0.sp,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Qnty: $totalQuantity',
                                                style: TextStyle(
                                                  fontSize: 16.0.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}
