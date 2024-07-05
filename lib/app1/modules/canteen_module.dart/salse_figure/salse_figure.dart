import 'dart:developer';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/salse_figure_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/utils/no_salse.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/utils/shrimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SalseFigure extends StatelessWidget {
  final String date;
  SalseFigure({super.key, required this.date});

  final salsefigureController = Get.put(SalesFigureController());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserOrderResponse>>(
        stream: salsefigureController.getAllOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SalseShrimmer();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoSalse();
          }

          var orders = snapshot.data!;
          Map<String, ProductDetail> aggregatedQuantities =
              salsefigureController.aggregateProductQuantities(orders);
          double totalGrossSales = salsefigureController
              .calculateTotalGrossSales(aggregatedQuantities);

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 245, 255, 255),
                  Color.fromARGB(255, 200, 232, 200)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(66, 109, 109, 109),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gross Sales',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromARGB(179, 60, 58, 58),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '\NPR ${NumberFormat('#,##,###').format(totalGrossSales)}',
                  style: TextStyle(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 17, 17, 17),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
