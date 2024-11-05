import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/account_info_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClassUpdate extends StatelessWidget {
  final String initialName;
  final String userId;

  ClassUpdate({
    Key? key,
    required this.userId,
    required this.initialName,
  }) : super(key: key);

  final accountInfoController = Get.put(AccountInfoController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            titleSpacing: 4.0,
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
                    'Class Change',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
          ),
          body: StreamBuilder<List<String>>(
            stream: accountInfoController
                .getClassNames('texasinternationalcollege'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: LoadingWidget());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text('Error loading classes'),
                    ],
                  ),
                );
              }

              final classList = snapshot.data ?? [];
              if (classList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined, color: Colors.grey, size: 48),
                      SizedBox(height: 16),
                      Text('No classes available'),
                    ],
                  ),
                );
              }

              // Initialize newClass if it's not set
              if (accountInfoController.newClass.value == 'Select Class') {
                accountInfoController.newClass.value = classList.first;
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Class Section
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.grey[600], size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Current Class',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.school_outlined,
                                    color: Colors.grey[800]),
                                SizedBox(width: 12),
                                Text(
                                  initialName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // New Class Selection
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.edit_outlined,
                                  color: Colors.grey[600], size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Select New Class',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: classList.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                              itemBuilder: (context, index) {
                                final className = classList[index];
                                return GetX<AccountInfoController>(
                                  builder: (controller) {
                                    final isSelected =
                                        controller.newClass.value == className;
                                    return ListTile(
                                      onTap: () {
                                        controller.newClass.value = className;
                                      },
                                      tileColor: isSelected
                                          ? Colors.grey[50]
                                          : Colors.white,
                                      title: Text(
                                        className,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.black87,
                                        ),
                                      ),
                                      trailing: isSelected
                                          ? Icon(Icons.check_circle,
                                              color: Colors.green, size: 20)
                                          : null,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Update Button
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: GetX<AccountInfoController>(
                        builder: (controller) => CustomButton(
                          isLoading:
                              controller.loading.value == true ? false : false,
                          text: 'Update Class',
                          onPressed: () {
                            if (controller.newClass.value != initialName &&
                                controller.newClass.value != 'Select Class') {
                              controller.doCalssUpdae(
                                userId,
                                controller.newClass.value,
                              );
                            } else {
                              Get.snackbar(
                                'Select Different Class',
                                'Please select a different class to update',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                            }
                          },
                          buttonColor: Colors.black,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
    );
  }
}
