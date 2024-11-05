import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderTilesShrimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontalPadding,
      child: Container(
        padding: EdgeInsets.all(8.0),
        // margin: EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.shrimmerColorText,
                    child: Text(
                      " order.productName",
                      style: TextStyle(
                        color: AppColors.shrimmerColorText,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      Container(
                        color: AppColors.shrimmerColorText,
                        child: Text(
                          '"NPR {order.price}"',
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              color: AppColors.shrimmerColorText,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Container(
                        color: AppColors.shrimmerColorText,
                        child: Icon(
                          Icons.alarm_outlined,
                          size: 17.sp,
                          color: AppColors.shrimmerColorText,
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Container(
                        color: AppColors.shrimmerColorText,
                        child: Text(
                          '{order. }',
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              color: AppColors.shrimmerColorText,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 17.sp,
                        color: AppColors.shrimmerColorText,
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Container(
                        color: AppColors.shrimmerColorText,
                        child: Text(
                          '{order.customer}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: AppColors.shrimmerColorText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.shrimmerColorText,
                      borderRadius: BorderRadius.circular(16)),
                  width: 14.h,
                  height: 14.h,
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.shrimmerColorText,
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 1.5),
                        child: Text(
                          "My Order",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.shrimmerColorText),
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
