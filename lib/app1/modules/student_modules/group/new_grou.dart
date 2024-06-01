import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewGroup extends StatelessWidget {
  final groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            titleSpacing: 4.0, // Adjusts the spacing above the title
            title: Text(
              'Community',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0.w),
                  child: Text(
                    'Creat your own group',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: groupController.groupFormKey,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      "Create your own group and start enjoying the group order. Make dining a better experience.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 19.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),

                  TextFormFieldWidget(
                    showIcons: false,
                    textInputType: TextInputType.text,
                    hintText: "Group Name",
                    controller: groupController.groupNameController,
                    validatorFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return "Group name is required";
                      }
                      return null;
                    },
                    actionKeyboard: TextInputAction.next,
                    prefixIcon: const Icon(Icons.group),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  TextFormFieldWidget(
                    readOnly: false,
                    showIcons: false,
                    textInputType: TextInputType.number,
                    hintText: "Group Code (4-digit)",
                    controller: groupController.groupCodeController,
                    validatorFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Group code is required';
                      }
                      if (value.length != 4 ||
                          !RegExp(r'^\d{4}$').hasMatch(value)) {
                        return 'Please enter a valid 4-digit group code';
                      }
                      return null;
                    },
                    actionKeyboard: TextInputAction.next,
                    prefixIcon: const Icon(Icons.code),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Create',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      groupController.creategrout();
                    },
                    isLoading: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 40.h,
            left: 40.w,
            child: Obx(() => groupController.groupCreateLoading.value
                ? LoadingWidget()
                : SizedBox.shrink()))
      ],
    );
  }
}
