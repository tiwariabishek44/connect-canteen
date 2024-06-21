import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:connect_canteen/app1/widget/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupDelete extends StatefulWidget {
  final String groupcod;
  GroupDelete({super.key, required this.groupcod});

  @override
  State<GroupDelete> createState() => _GroupDeleteState();
}

class _GroupDeleteState extends State<GroupDelete> {
  bool _isChecked = false;

  TextEditingController _controller = TextEditingController();
  final groupController = Get.put(GroupController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            titleSpacing: 4.0, // Adjusts the spacing above the title
            title: Text("Setting"),

            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0.w),
                  child: Text(
                    'Delete Group',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deleting a group will remove all associated data. This action cannot be undone.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  "Please type the code of the group to confirm deletion:",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5.h),
                Form(
                  key: groupController.formKey,
                  child: TextFormFieldWidget(
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
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "I understand that this action cannot be undone.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Delete Group',
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    widget.groupcod != groupController.groupCodeController.text
                        ? CustomSnackbar.error(
                            Get.context!, 'Such Group Does not exist!')
                        : groupController.deleteGro(
                            groupController.groupCodeController.text);
                  },
                  isLoading: false,
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 40.h,
            left: 40.w,
            child: Obx(() => groupController.deleteLoading.value
                ? LoadingWidget()
                : SizedBox.shrink()))
      ],
    );
  }
}
