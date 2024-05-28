import 'package:connect_canteen/app1/modules/wallet/utils/arrow_container.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
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
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '\Rs.100',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ArrowContainer(
                arrowIcon: Icons.arrow_upward,
                text: 'Rs.100',
                isUpward: true,
              ),
              SizedBox(width: 2.w),
              ArrowContainer(
                arrowIcon: Icons.arrow_downward,
                text: 'Rs.100',
                isUpward: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
