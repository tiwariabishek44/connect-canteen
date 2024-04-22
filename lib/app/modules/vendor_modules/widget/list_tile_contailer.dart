import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ListTileContainer extends StatelessWidget {
  final String name;
  final int quantit;
  const ListTileContainer(
      {super.key, required this.name, required this.quantit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: Color.fromARGB(
              255, 238, 236, 236), // Background color of the container
          borderRadius: BorderRadius.circular(10), // Border radius if needed
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 238, 235, 235)
                  .withOpacity(0.5), // Shadow color
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: Offset(0, 3), // Offset
            ),
          ],
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: AppStyles.listTilesubTitle,
              ),
              Text(
                "$quantit-plate",
                style: AppStyles.titleStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
