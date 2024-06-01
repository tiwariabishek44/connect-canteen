import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/listtile_shrimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupMemberField extends StatelessWidget {
  GroupMemberField({super.key, required this.groupid});

  final String groupid;
  final groupController = Get.put(GroupController());
  final storage = GetStorage();

  void _showGroupNameDialog(BuildContext context, String name, String userid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Adjust border radius as needed
          ),
          title: Text(
            'Remove  $name',
            style: TextStyle(
              fontSize: 17.5.sp,
              color: Color.fromARGB(221, 37, 36, 36),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'User will no longer be able to order food under this group.',
            style: TextStyle(
              color: const Color.fromARGB(221, 72, 71, 71),
              fontSize: 16.0.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog

                Get.back();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.purple),
              ),
            ),
            GestureDetector(
              onTap: () async {
                bool isexist = true;
                if (isexist) {
                  Get.back();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        child: contentBox(context),
                      );
                    },
                  );
                } else {
                  Get.back();
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Remove",
                  style: TextStyle(
                    color: Color.fromARGB(255, 225, 6, 6),
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  Icons.warning,
                  color: Color.fromARGB(255, 255, 17, 0),
                  size: 30.sp,
                ),
                SizedBox(height: 20),
                const Text(
                  'Cannot Remove User',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'User have ordered under this group.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StudentDataResponse>>(
      stream: groupController.getMemberStream(groupid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: ((context, index) {
                return ListtileShrimmer();
              }));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final students = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: students.length,
            itemBuilder: (context, index) {
              StudentDataResponse student = students[index]!;

              return ListTile(
                onTap: () {
                  _showGroupNameDialog(context, student.name, student.userid);
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
                                backgroundColor:
                                    const Color.fromARGB(255, 224, 218, 218),
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 224, 218, 218),
                                ),
                                imageUrl: student?.profilePicture ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape:
                                        BoxShape.circle, // Apply circular shape
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 224, 218, 218),
                                ),
                              ),
                      ),
                    ),
                    student?.userid == storage.read(userId)
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 7.5,
                              backgroundColor: Color.fromARGB(
                                  255, 72, 2, 129), // Adjust color as needed
                              child: Icon(
                                Icons.shield_outlined,
                                color: Colors.white,
                                size: 15,
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
          );
        }
      },
    );

    // StreamBuilder<List<GroupMemberModel?>>(
    //   stream: groupController.getGroupMember(groupid),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       return SizedBox.shrink();
    //     } else if (snapshot.data == null) {
    //       return Container();
    //     } else {
    //       final List<StudentDataResponse?> students = snapshot.data ?? [];

    // return Expanded(
    //   child: ListView.builder(
    //     itemCount: students.length,
    //     itemBuilder: (context, index) {
    //       StudentDataResponse student = students[index]!;
    //       log("the dtudetn data are ${students[index]!.name}");
    //       return ListTile(
    //         leading: Stack(
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.white,
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.grey.withOpacity(0.5),
    //                     spreadRadius: 2,
    //                     blurRadius: 5,
    //                     offset: Offset(0, 3),
    //                   ),
    //                 ],
    //               ),
    //               child: CircleAvatar(
    //                 radius: 22.sp,
    //                 backgroundColor: Colors.white,
    //                 child: student?.profilePicture == ''
    //                     ? CircleAvatar(
    //                         radius: 21.4.sp,
    //                         child: Icon(
    //                           Icons.person,
    //                           color: Colors.white,
    //                         ),
    //                         backgroundColor:
    //                             const Color.fromARGB(255, 224, 218, 218),
    //                       )
    //                     : CachedNetworkImage(
    //                         progressIndicatorBuilder:
    //                             (context, url, downloadProgress) =>
    //                                 CircleAvatar(
    //                           radius: 21.4.sp,
    //                           child: Icon(
    //                             Icons.person,
    //                             color: Colors.white,
    //                           ),
    //                           backgroundColor: const Color.fromARGB(
    //                               255, 224, 218, 218),
    //                         ),
    //                         imageUrl: student?.profilePicture ?? '',
    //                         imageBuilder: (context, imageProvider) =>
    //                             Container(
    //                           decoration: BoxDecoration(
    //                             shape: BoxShape
    //                                 .circle, // Apply circular shape
    //                             image: DecorationImage(
    //                               image: imageProvider,
    //                               fit: BoxFit.cover,
    //                             ),
    //                           ),
    //                         ),
    //                         fit: BoxFit.fill,
    //                         width: double.infinity,
    //                         errorWidget: (context, url, error) =>
    //                             CircleAvatar(
    //                           radius: 21.4.sp,
    //                           child: Icon(
    //                             Icons.person,
    //                             color: Colors.white,
    //                           ),
    //                           backgroundColor: const Color.fromARGB(
    //                               255, 224, 218, 218),
    //                         ),
    //                       ),
    //               ),
    //             ),
    //             student?.userid == storage.read(userId)
    //                 ? Positioned(
    //                     bottom: 0,
    //                     right: 0,
    //                     child: CircleAvatar(
    //                       radius: 7.5,
    //                       backgroundColor: Color.fromARGB(
    //                           255, 72, 2, 129), // Adjust color as needed
    //                       child: Icon(
    //                         Icons.shield_outlined,
    //                         color: Colors.white,
    //                         size: 15,
    //                       ),
    //                     ),
    //                   )
    //                 : SizedBox.shrink()
    //           ],
    //         ),
    //         title: Text(
    //           "${student?.name}",
    //           style: TextStyle(
    //             fontSize: 18.sp,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         subtitle: Text(
    //           "${student?.phone}",
    //           style: TextStyle(
    //             fontSize: 16.sp,
    //             color: Colors.grey,
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
    //     }
    //   },
    // );
  }
}
