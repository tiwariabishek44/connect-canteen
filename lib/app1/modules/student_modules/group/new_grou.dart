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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 26.sp,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ),
            title: Text(
              'Create New Group',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5D56F4), Color(0xFF69B4FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
