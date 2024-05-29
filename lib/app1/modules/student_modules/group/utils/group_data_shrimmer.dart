import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupFieldShrimmer extends StatelessWidget {
  const GroupFieldShrimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
              style:
                  TextStyle(fontSize: 18, color: AppColors.shrimmerColorText),
            ),
          ),
          SizedBox(height: 5),
          Container(
            color: AppColors.shrimmerColorText,
            child: Text(
              '\NPR 100.00',
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
  }
}
