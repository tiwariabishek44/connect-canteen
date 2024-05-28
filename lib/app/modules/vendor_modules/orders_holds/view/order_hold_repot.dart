import 'dart:developer';

import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/widget/listview_widget.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/list_tile_contailer.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHOldReport extends StatefulWidget {
  @override
  State<OrderHOldReport> createState() => _OrderHOldReportState();
}

class _OrderHOldReportState extends State<OrderHOldReport> {
  final orderholdController = Get.put(CanteenHoldOrders());
  int selectedIndex = -1;

  String dat = '';

  @override
  void initState() {
    super.initState();
    checkTimeAndSetDate();
  }

  void checkTimeAndSetDate() {
    DateTime currentDate = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    setState(() {
      selectedIndex = 0;
      dat = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    });
    orderholdController.fetchHoldMeal(selectedIndex.toInt(), dat);
    // 1 am or later
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    orderholdController.date.value = formattedDate;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Daily Order Hold',
        iconrequired: true,
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: timeSlots.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;

                              orderholdController.fetchHoldMeal(
                                  selectedIndex.toInt(), dat);
                            });
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: selectedIndex == index
                                  ? Color.fromARGB(255, 9, 9, 9)
                                  : const Color.fromARGB(255, 247, 245, 245),
                            ),
                            child: Center(
                              child: Text(
                                timeSlots[index],
                                style: TextStyle(
                                    fontSize: 17.0.sp,
                                    color: selectedIndex == index
                                        ? AppColors.backgroundColor
                                        : Color.fromARGB(255, 84, 82, 82)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
                flex: 13,
                child: Obx(() {
                  if (orderholdController.isloading.value) {
                    // Show a loading screen while data is being fetched
                    return LoadingWidget();
                  } else {
                    if (orderholdController
                                .holdOrderReportResponse.value.response ==
                            null ||
                        orderholdController
                            .holdOrderReportResponse.value.response!.isEmpty) {
                      // Show an empty cart page if there are no orders available
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No OrderHold Today',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: ListviewWidget(
                          dashboard: false,
                          itemlist: orderholdController.productQuantities,
                        ),
                      );
                    }
                  }
                })),
          ],
        ),
      ),
    );
  }
}
