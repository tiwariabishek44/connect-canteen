import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WelcomeHeading extends StatelessWidget {
  final String mainHeading;
  final String subHeading;

  const WelcomeHeading({
    super.key,
    required this.mainHeading,
    required this.subHeading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${mainHeading}!",
            style: AppStyles.listTileTitle.copyWith(fontSize: 23.sp),
          ),
          Text(
            subHeading,
            style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor),
          ),
        ],
      ),
    );
  }
}
