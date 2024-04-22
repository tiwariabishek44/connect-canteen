import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomPopup extends StatelessWidget {
  final VoidCallback onBack;
  final String message;

  const CustomPopup({Key? key, required this.onBack, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        children: [
          Container(
            height: 20.h,
            width: 80.w,
            color: Colors.green,
            child: const Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.white,
            ),
          ),
          Container(
            height: 20.h,
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Great !',
                  style: AppStyles.mainHeading,
                ),
                SizedBox(height: 1.h),
                Text('${message}', style: AppStyles.listTileTitle),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 8),
                        child: Text(
                          " OK",
                          style: AppStyles.buttonText,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
