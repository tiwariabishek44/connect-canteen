import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/friend_list/friend_list.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/new_grou.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/group_data_field.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/group_member_fetch.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/no_group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupPage extends StatelessWidget {
  final loignController = Get.put(LoginController());
  final groupController = Get.put(GroupController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Group Page',
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
        padding: const EdgeInsets.all(11.0),
        child: StreamBuilder<StudentDataResponse?>(
          stream: loignController.getStudetnData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return SizedBox.shrink();
            } else if (snapshot.data == null) {
              return NoGroupField();
              
            } else {
              StudentDataResponse studetnData = snapshot.data!;
              groupController.moderatorName.value = studetnData.name;
              if (studetnData.groupid == '') {
                groupController.nogroup.value = true;
                return NoGroupField();
              } else {
                groupController.nogroup.value = false;
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GroupDataField(
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
                          child: Text(
                            "All orders placed by group members are grouped together.",
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          height: 20,
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        GroupMemberField(
                          groupid: studetnData.groupid,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Obx(() => groupController.nogroup.value
                          ? SizedBox.fromSize()
                          : FloatingActionButton(
                              onPressed: () {
                                Get.to(() => FriendsPage(
                                    grade: studetnData.classes.toString()));
                                // Add friend action
                              },
                              backgroundColor: Color.fromARGB(221, 19, 20, 22),
                              child: Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                            )),
                    )
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}
