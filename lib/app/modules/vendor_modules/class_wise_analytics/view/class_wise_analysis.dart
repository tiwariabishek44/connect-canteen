import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/class_reoprt_controller.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/view/class_remaning_order_tab.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Classanalytics extends StatefulWidget {
  @override
  State<Classanalytics> createState() => _ClassanalyticsState();
}

class _ClassanalyticsState extends State<Classanalytics> {
  final orderController = Get.put(ClassReportController());
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Color(0xff06C167),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Penalty Charge",
                    style: AppStyles.appbar,
                  ),
                  Text(
                    formattedDate,
                    style: AppStyles.listTilesubTitle1,
                  ),
                ],
              ),
            ),
          ),
          body: ClassRemaningOrdersTab()),
    );
  }
}
