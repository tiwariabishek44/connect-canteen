import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MenueEditShrimmer extends StatelessWidget {
  const MenueEditShrimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 248, 246, 246),
          highlightColor: Color.fromARGB(255, 230, 227, 227),
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Container(
              width: double.infinity,
              height: 200,
              color: AppColors.shrimmerColorText,
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 248, 246, 246),
          highlightColor: Color.fromARGB(255, 230, 227, 227),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                  height: 0.5.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                      color:
                          AppColors.shrimmerColorText, // Changed color to green
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start, // Added this line
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: AppColors.shrimmerColorText,
                      child: Text(
                        "menueProduct.name",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.shrimmerColorText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: AppColors.shrimmerColorText,
                        child: Text(
                          '/plate',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.shrimmerColorText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColors.shrimmerColorText,
                child: Text(
                  "Rs.2d00",
                  style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.shrimmerColorText),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 3.h),
        Divider(
          height: 0.4.h,
          thickness: 0.4.h,
          color: Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
        ),
      ],
    );
    ;
  }
}
