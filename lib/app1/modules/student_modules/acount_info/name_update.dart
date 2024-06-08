import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/account_info_controller.dart';
import 'package:connect_canteen/app1/widget/black_textform_field.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NameUpdate extends StatelessWidget {
  final String initialName;
  final String userId;

  NameUpdate({Key? key, required this.initialName, required this.userId})
      : super(key: key);
  final accountInfoController = Get.put(AccountInfoController());
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: initialName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'User Account',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "This is the name you would like other people to use when refering to you",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 19.sp,
                        color: Colors.black),
                  ),
                ),
                Form(
                  key: accountInfoController.nameForm,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: BlackTextFormField(
                      prefixIcon: const Icon(Icons.person),
                      textInputType: TextInputType.text,
                      hintText: 'Name',
                      controller: nameController,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return '  Name Can\'t be empty';
                        }
                        return null;
                      },
                      actionKeyboard: TextInputAction.next,
                      onSubmitField: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    isLoading: false,
                    text: 'Update',
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      accountInfoController.doUpdate(
                          userId, nameController.text.trim());
                    },
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 40.h,
              left: 40.w,
              child: Obx(() => accountInfoController.loading.value
                  ? LoadingWidget()
                  : SizedBox.shrink()))
        ],
      ),
    );
  }
}
