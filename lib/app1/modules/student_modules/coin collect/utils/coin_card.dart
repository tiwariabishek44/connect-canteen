import 'dart:developer';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/coin%20collect/coin_collect_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoinCard extends StatelessWidget {
  final coinCollectController = Get.put(CoinCollectController());
  final String userid;

  CoinCard({super.key, required this.userid});
  @override
  Widget build(BuildContext context) {
    log("this is user id ::::: $userid   ");
    return Column(
      children: [
        StreamBuilder<List<TransctionResponseMode>>(
            stream: coinCollectController.fetchCoinsLog(
                userid, 'texasinternationalcollege'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 237, 240, 240),
                        Color.fromARGB(255, 218, 218, 218)
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
                      Container(
                        color: AppColors.shrimmerColorText,
                        child: Text(
                          'Coin COLLECTED',
                          style: TextStyle(
                              fontSize: 18, color: AppColors.shrimmerColorText),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        color: AppColors.shrimmerColorText,
                        child: Text(
                          '\NPR 00.00',
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.shrimmerColorText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return SizedBox.shrink();
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                        'Coin COLLECTED',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(179, 60, 58, 58),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '0.00',
                        style: TextStyle(
                          fontSize: 27.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 17, 17, 17),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                List<TransctionResponseMode> transactions = snapshot.data!;
                Map<String, double> totals =
                    coinCollectController.calculateTotals(transactions);
                double totalBalance = totals['totalcollect'] ?? 0.0;

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
                        'Coin COLLECTED',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(179, 60, 58, 58),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Image.asset(
                            'assets/coin.jpeg',
                            height: 10.h,
                            width: 10.w,
                          ),
                          Text(
                            '$totalBalance',
                            style: TextStyle(
                              fontSize: 27.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 17, 17, 17),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            }),
      ],
    );

    // oooooo
  }
}
