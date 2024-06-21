import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/friend_list/friend_list.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/new_grou.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/group_Delete.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/group_data_field.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/group_member_fetch.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/listtile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/no_group.dart';
import 'package:connect_canteen/app1/modules/student_modules/pin/utils/noPin.dart';
import 'package:connect_canteen/app1/modules/student_modules/pin/utils/pin_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PinPage extends StatelessWidget {
  final loignController = Get.put(LoginController());
  final groupController = Get.put(GroupController());
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text("Security Pin"),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Account Pin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: StreamBuilder<StudentDataResponse?>(
          stream: loignController.getStudetnData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: ((context, index) {
                    return ListtileShrimmer();
                  }));
            } else if (snapshot.hasError) {
              return SizedBox.shrink();
            } else {
              StudentDataResponse studetnData = snapshot.data!;
              groupController.moderatorName.value = studetnData.name;
              if (studetnData.groupid == '') {
                groupController.nogroup.value = true;
                return NoPinField();
              } else {
                groupController.nogroup.value = false;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PinField(
                        groupid: studetnData.groupid,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "All orders placed under this pin .",
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.settings),
                            //   onPressed: () {
                            //     Get.to(
                            //         () => GroupDelete(
                            //               groupcod: studetnData.groupcod,
                            //             ),
                            //         transition: Transition.cupertinoDialog);
                            //     // Add your onPressed code here!
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
