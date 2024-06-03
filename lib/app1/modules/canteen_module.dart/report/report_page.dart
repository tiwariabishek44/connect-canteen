import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/modules/vendor_modules/daily_report/widget/reaming_order.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/product_detials_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/utils/order_tile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/canteen_report_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/utils/remaning_order_section.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/utils/requiremetn.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/salse_figure.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CanteenDailyReport extends StatelessWidget {
  final canteenDailyReport = Get.put(CanteenReportController());
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          formattedDate,
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Daily Report',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            SalseFigure(),
            SizedBox(
              height: 5.h,
            ),
            RequirementSection(),
            SizedBox(
              height: 4.h,
            ),
            RemaningOrderSection(),
            SizedBox(
              height: 4.h,
            ),
          ],
        ),
      )),
    );
  }
}
