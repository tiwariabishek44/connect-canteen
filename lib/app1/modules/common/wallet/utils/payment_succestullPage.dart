import 'dart:developer';

import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SuccesfullPayment extends StatelessWidget {
  final int amountPaid;

  SuccesfullPayment({
    required this.amountPaid,
  });

  Widget build(BuildContext context) {
    // log('PaymentSuccessPage: amountPaid: $amountPaid');

    String formattedAmount = NumberFormat('#,##,###').format(amountPaid);

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Image.asset('assets/payments.png'),
          SizedBox(height: 10),
          Text(
            'Successful',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 199, 199, 199),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rs. ',
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedAmount,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
