import 'dart:developer';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BalanceCard extends StatelessWidget {
  final transctionController = Get.put(TransctionController());
  final String userid;

  BalanceCard({super.key, required this.userid});
  @override
  Widget build(BuildContext context) {
    log("this is user id ::::: $userid   ");
    return Column(
      children: [

StreamBuilder<List<TransctionResponseMode>>(
            stream: transctionController.fetchAllTransction(
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
                        'Wallet BALANCE',
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
                      'Wallet BALANCE',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(179, 60, 58, 58),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '\NPR 0.00',
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
                    transctionController.calculateTotals(transactions);
              double totalBalance = totals['totalBalance'] ?? 0.0;

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
                      'Wallet BALANCE',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(179, 60, 58, 58),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                        '\NPR $totalBalance',
                      style: TextStyle(
                        fontSize: 27.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 17, 17, 17),
                      ),
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
