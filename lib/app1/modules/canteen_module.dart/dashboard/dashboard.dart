import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/dashboard/utils/manager_activity.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/dashboard/utils/payment_activity.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/dashboard/utils/salse_activity.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/salse_figure.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CanteenDashboard extends StatelessWidget {
  CanteenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final formattedDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0.w, // Adjusts the spacing above the title
        title: Text(
          '${formattedDate}',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Dashboard',
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
                height: 2.h,
              ),
              SalseFigure(
                date: formattedDate,
              ),
              SizedBox(
                height: 2.h,
              ),
              PaymentActivity(
                date: formattedDate,
              ),
              SizedBox(
                height: 2.h,
              ),
              ManagerActivity(
                date: formattedDate,
              ),
              SizedBox(
                height: 2.h,
              ),
              // SalseActivity(),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
