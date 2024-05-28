import 'dart:developer';

import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:connect_canteen/app/widget/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewGroupCreate extends StatelessWidget {
  NewGroupCreate({
    Key? key,
  }) : super(key: key);
  final groupController = Get.put(GroupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Form(
            key: groupController.newGroupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Enter the 4-digit group code",
                  style: AppStyles.mainHeading,
                ),
                SizedBox(
                  height: 1.h,
                ),

                SizedBox(
                  height: 3.h,
                ),
                Center(
                  child: Pinput(
                    keyboardType: TextInputType.number,
                    length: 4,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the 4-digit code';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter digits only';
                      }
                      return null;
                    },
                    onCompleted: (pin) {
                      groupController.groupCode.value = pin;
                    },
                    onChanged: (String? value) {
                      if (value!.isEmpty || value.length < 4) {
                        groupController.otpError.value = true;
                      } else {
                        groupController.otpError.value = false;
                      }
                    },
                  ),
                ),
                SizedBox(height: 4.h),

                Text(
                  "Enter the group name ",
                  style: AppStyles.listTileTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
                SizedBox(height: 1.h), // Adjust as needed

                CustomizedTextfield(
                  keyboardType: TextInputType.name,
                  validator: groupController.textVaidator,
                  icon: Icons.password,
                  myController: groupController.groupnameController,
                  hintText: "Enter Group Name ",
                ),

                Obx(() => CustomButton(
                      text: 'Confirm',
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        groupController.otpError.value
                            ? log(" Enter the 4 digit otp")
                            : groupController.createGroup(context);
                      },
                      isLoading: groupController.groupCreateLoading.value,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
