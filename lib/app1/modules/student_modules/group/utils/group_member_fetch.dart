import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupMemberField extends StatelessWidget {
  GroupMemberField({super.key, required this.groupid});

  final String groupid;
  final groupController = Get.put(GroupController());
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StudentDataResponse>>(
      stream: groupController.getMemberStream(groupid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final students = snapshot.data!;
          log(" the total length is ${students.length}");
          return Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                StudentDataResponse student = students[index]!;
                log("the dtudetn data are ${students[index]!.name}");
                return ListTile(
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
            ),
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
