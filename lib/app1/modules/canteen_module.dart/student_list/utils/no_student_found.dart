import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoStudetnFound extends StatelessWidget {
  const NoStudetnFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.0.w, horizontal: 5.0.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 50.sp,
              color: Colors.blue.shade300,
            ),
            SizedBox(height: 2.h),
            Text(
              'No Studetn Found',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Please try again later',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.blue.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
