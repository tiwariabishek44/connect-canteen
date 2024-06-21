import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/photo_upload.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PhotoPermission extends StatelessWidget {
  const PhotoPermission({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 243, 243),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Profile Photo",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                'Your profile photo will be used to identify you in the app.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 4.h,
              ),
              CustomButton(
                isLoading: false,
                text: 'Update Photo',
                onPressed: () {
                  Get.off(
                      () => PhotoUPload(
                            studentid: studentId,
                          ),
                      transition: Transition.cupertinoDialog);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
