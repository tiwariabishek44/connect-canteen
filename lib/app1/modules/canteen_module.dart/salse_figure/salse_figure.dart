import 'dart:developer';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/salse_figure_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/utils/no_salse.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/utils/shrimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SalseFigure extends StatelessWidget {
  final String date;
  SalseFigure({super.key, required this.date});

  final salsefigureController = Get.put(SalseFigureController());

  @override
  Widget build(BuildContext context) {
    log(" this i our date");
    return StreamBuilder<List<OrderResponse>>(
        stream: salsefigureController.getAllOrder(date),
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
          salsefigureController.calculateTotals(orders);
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
                    fontSize: 18,
                    color: const Color.fromARGB(179, 60, 58, 58),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '\NPR ${salsefigureController.grandTotal.value.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 17, 17, 17),
                  ),
                ),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      Text(
                        '\NPR ${salsefigureController.netTotal.value.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 192, 156, 11),
                        ),
                      ),
                      const Text(
                        'Net Sales',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(179, 60, 58, 58),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
