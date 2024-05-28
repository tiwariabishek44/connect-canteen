import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'custom_elevated_button.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String buttonText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(height: 3.h),
          CustomElevatedButton(
            onPressed: onTap,
            text: buttonText,
            width: 10.w,
            height: 6.h,
            borderRadius: 10.0,
          ),
        ],
      ),
    );
  }
}
