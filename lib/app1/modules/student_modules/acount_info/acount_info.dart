import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/account_info_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/class_update.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/name_update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({super.key});
  final accountInfoController = Get.put(AccountInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                'Account Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Stack(
                  children: [
                    CircleAvatar(
                      radius: 35.sp,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.4),
                      child: accountInfoController.image.value.path.isEmpty
                          ? CircleAvatar(
                              radius: 33.4.sp,
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
                                width: 35
                                    .w, // Adjust the width and height as needed
                                height: 35.w,
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
              height: 5.h,
            ),
            Text(
              " Basic info",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19.sp),
            ),
            SizedBox(
              height: 1.h,
            ),
            buildCustomListTile(
                onTap: () {
                  Get.to(
                      () => NameUpdate(
                            initialName: "Abishek Tiwari",
                          ),
                      transition: Transition.cupertinoDialog);
                },
                title: 'Name ',
                subtitle: 'Abishek Tiwari',
                trailing: Icons.chevron_right),
            buildCustomListTile(
                onTap: () {
                  Get.to(
                      () => ClassUpdate(
                            initialName: "Class",
                            classOptions: ['Class 1', "Class 2", "Class 3"],
                          ),
                      transition: Transition.cupertinoDialog);
                },
                title: 'Class ',
                subtitle: 'Class 12',
                trailing: Icons.chevron_right),
            buildCustomListTile(
                onTap: () {},
                title: 'Phone number ',
                subtitle: '9742555741',
                trailing: Icons.chevron_right),
            buildCustomListTile(
                onTap: () {},
                title: 'Email ',
                subtitle: 'tiwariabishek44@gmail.com',
                trailing: Icons.chevron_right)
          ],
        ),
      ),
    );
  }

  Widget buildCustomListTile({
    required String title,
    required String subtitle,
    required IconData trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 19.sp, color: Colors.black),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 17.sp,
            color: Colors.grey[700]),
      ),
      trailing: Icon(
        trailing,
        color: Colors.grey[700],
      ),
      onTap: onTap,
    );
  }
}
