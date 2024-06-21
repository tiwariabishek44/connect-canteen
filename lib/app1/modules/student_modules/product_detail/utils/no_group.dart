import 'package:connect_canteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoGroup extends StatelessWidget {
  final String heading;
  final String subheading;

  const NoGroup({required this.heading, required this.subheading, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: 27.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white,
        ),
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                      height: 0.5.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                          color: Colors.green, // Changed color to green
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0.h),
                child: Column(
                  children: [
                    Text(heading,
                        style: TextStyle(
                            fontSize: 27.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            subheading,
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 119, 116, 116)),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
