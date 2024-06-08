import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/account_info_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PhotoUPload extends StatelessWidget {
  PhotoUPload({super.key, required this.studentid});
  final String studentid;
  final accountInfoController = Get.put(AccountInfoController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 4.0, // Adjusts the spacing above the title
            title: Text("User Accounts"),

            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0.w),
                  child: Text(
                    'Update Profile Picture',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: AppPadding.screenHorizontalPadding,
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => Stack(
                      children: [
                        CircleAvatar(
                          radius: 45.sp,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.4),
                          child: accountInfoController.image.value.path.isEmpty
                              ? CircleAvatar(
                                  radius: 45.4.sp,
                                  child: Icon(
                                    Icons.person,
                                    size: 38.sp,
                                    color: Colors.white,
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 224, 218, 218),
                                )
                              : ClipOval(
                                  child: Image.file(
                                    accountInfoController.image.value!,
                                    fit: BoxFit.fill,
                                    width: 65
                                        .w, // Adjust the width and height as needed
                                    height: 65.w,
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 10.sp,
                          right: 16,
                          child: GestureDetector(
                            onTap: () {
                              accountInfoController.pickImages();
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 235, 232, 232),
                              radius: 20.sp,
                              child: Icon(
                                Icons.edit,
                                size: 20.0.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  isLoading: false,
                  text: 'Upload',
                  onPressed: () {
                    accountInfoController.image.value.path.isEmpty
                        ? CustomSnackbar.error(context, "Please Select Photo")
                        : accountInfoController.updateProfilePicture(studentid);
                  },
                )
              ],
            ),
          ),
        ),
        Obx(() => Positioned(
            top: 70.h,
            left: 40.w,
            child: accountInfoController.loading.value
                ? LoadingWidget()
                : SizedBox.shrink()))
      ],
    );
  }
}
