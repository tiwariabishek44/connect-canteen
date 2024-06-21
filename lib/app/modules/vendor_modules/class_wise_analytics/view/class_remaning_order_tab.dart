import 'dart:developer';

import 'package:connect_canteen/app/config/prefs.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/clase_wise_order/class_wise_order.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/clase_wise_order/class_wise_order_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/class_reoprt_controller.dart';

import 'package:connect_canteen/app/modules/vendor_modules/widget/list_tile_contailer.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClassRemaningOrdersTab extends StatefulWidget {
  const ClassRemaningOrdersTab({super.key});

  @override
  State<ClassRemaningOrdersTab> createState() => _ClassRemaningOrdersTabState();
}

class _ClassRemaningOrdersTabState extends State<ClassRemaningOrdersTab> {
  final classReportController = Get.put(ClassReportController());
  final classWiseOrderController = Get.put(ClassWiseOrderController());

  int selectedIndex = -1;

  String dat = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkTimeAndSetDate();
    });
  }

  void checkTimeAndSetDate() {
    DateTime currentDate = DateTime.now();
    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    setState(() {
      selectedIndex = 0;
      dat = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    });
    classReportController.fetchRemaningMeal(selectedIndex.toInt(), dat);

    // 1 am or later
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    classReportController.date.value = formattedDate;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Expanded(
              flex: 13,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  if (classReportController.isLoading.value) {
                    // Show a loading screen while data is being fetched
                    return LoadingScreen();
                  } else {
                    if (classReportController
                                .remaningOrderResponse.value.response ==
                            null ||
                        classReportController
                            .remaningOrderResponse.value.response!.isEmpty) {
                      // Show an empty cart page if there are no orders available
                      return EmptyCartPage(
                        onClick: () {},
                      );
                    } else {
                      return ListView.builder(
                        itemCount: classReportController
                            .remaningproductQuantities.length,
                        itemBuilder: (context, index) {
                          final productQuantity = classReportController
                              .remaningproductQuantities[index];
                          return GestureDetector(
                            onTap: () {
                              classWiseOrderController.className.value =
                                  productQuantity.className;
                              classWiseOrderController.fetchOrders();
                              Get.to(
                                  () => ClassWiseOrder(
                                        classs: productQuantity.className,
                                      ),
                                  transition: Transition.rightToLeft);
                            },
                            child: ListTileContainer(
                              name: productQuantity.className,
                              quantit: productQuantity.totalQuantity,
                            ),
                          );
                        },
                      );
                    }
                  }
                }),
              )),
        ],
      ),
    );
  }
}
