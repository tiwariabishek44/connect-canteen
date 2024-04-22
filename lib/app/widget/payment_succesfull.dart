import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String amountPaid;

  PaymentSuccessPage({
    required this.amountPaid,
  });

  Widget build(BuildContext context) {
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
            'Payment Successful',
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
                'Amount Paid: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\Rs ${amountPaid}', // Replace with your payment amount
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Payed By: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Esewa', // Replace with your payment amount
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
