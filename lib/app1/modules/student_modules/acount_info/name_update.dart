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
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0,
        title: Text(
          'User Account',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.sp,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(left: 4.0.w, bottom: 16, right: 4.0.w),
            child: Text(
              'Update Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Name Section
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "This name will be displayed to others when they interact with you",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Name Input Section
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: accountInfoController.nameForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Enter New Name',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: BlackTextFormField(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey[600],
                            ),
                            textInputType: TextInputType.text,
                            hintText: 'Full Name',
                            controller: nameController,
                            validatorFunction: (value) {
                              if (value.isEmpty) {
                                return 'Name cannot be empty';
                              }
                              if (value.trim() == initialName) {
                                return 'Please enter a different name';
                              }
                              return null;
                            },
                            actionKeyboard: TextInputAction.done,
                            onSubmitField: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        if (initialName.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Current: $initialName',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Update Button
                Container(
                  padding: EdgeInsets.all(16),
                  child: GetX<AccountInfoController>(
                    builder: (controller) => CustomButton(
                      isLoading: controller.loading.value,
                      text: 'Update Name',
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (accountInfoController.nameForm.currentState!
                                .validate() &&
                            nameController.text.trim() != initialName) {
                          accountInfoController.doUpdate(
                              userId, nameController.text.trim());
                        }
                      },
                      buttonColor: Colors.black,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading Overlay
          GetX<AccountInfoController>(
            builder: (controller) => controller.loading.value
                ? Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(child: LoadingWidget()),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
