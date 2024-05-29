import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/friend_list/studetn_list_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/listtile_shrimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FriendsPage extends StatelessWidget {
  final String grade;
  final studetnListControllre = Get.put(StudetnListController());

  FriendsPage({super.key, required this.grade});
  void showAlreadyInGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            'Sorry',
            style: TextStyle(
              fontSize: 17.5.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'User is already involved in a group.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0.sp,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          "Friends",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                '+ Add Friends',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<StudentDataResponse>>(
        stream: studetnListControllre.fetchClassStudent(grade),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListtileShrimmer();
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final students = snapshot.data!;

            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  StudentDataResponse student = students[index]!;

                  return ListTile(
                    onTap: () {
                      student.groupid.isNotEmpty
                          ? showAlreadyInGroupDialog(context)
                          : null;
                    },
                    leading: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 22.sp,
                            backgroundColor: Colors.white,
                            child: student?.profilePicture == ''
                                ? CircleAvatar(
                                    radius: 21.4.sp,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                        255, 224, 218, 218),
                                  )
                                : CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            CircleAvatar(
                                      radius: 21.4.sp,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 224, 218, 218),
                                    ),
                                    imageUrl: student?.profilePicture ?? '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, // Apply circular shape
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      radius: 21.4.sp,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 224, 218, 218),
                                    ),
                                  ),
                          ),
                        ),
                        student?.groupid != ''
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 7.5,
                                  backgroundColor: Color.fromARGB(
                                      255, 0, 0, 0), // Adjust color as needed
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 9,
                                  ),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    title: Text(
                      "${student?.name}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${student?.phone}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
