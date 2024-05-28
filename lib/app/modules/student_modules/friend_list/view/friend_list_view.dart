import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/student_modules/friend_list/friend_list_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class FriendList extends StatelessWidget {
  final String groupId;

  // Constructor with groupId parameter
  FriendList({Key? key, required this.groupId}) : super(key: key);

  final friendListController = Get.put(FriendListController());
  void showAlreadyInGroupDialog(BuildContext context) {
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
            'Sorry',
            style: TextStyle(
              fontSize: 17.5.sp,
              color: Color.fromARGB(221, 37, 36, 36),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'User is already involved in a group.',
            style: TextStyle(
              color: const Color.fromARGB(221, 72, 71, 71),
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
      appBar: const CustomAppBar(title: "Friend List"),
      body: Stack(
        children: [
          Obx(() {
            if (friendListController.fetchLoading.value) {
              return LoadingWidget();
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ListView.builder(
                  itemCount: friendListController
                      .friendListResponse.value.response!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: ListTile(
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
                                  radius: 21.4.sp,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 224, 218, 218),
                                ),
                              ),
                              Obx(() {
                                if (friendListController
                                    .friendListResponse
                                    .value
                                    .response![index]
                                    .groupid
                                    .isNotEmpty) {
                                  return Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 7.5,
                                      backgroundColor: Color.fromARGB(255, 0, 0,
                                          0), // Adjust color as needed
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 9,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors
                                          .transparent, // Adjust color as needed
                                    ),
                                  );
                                }
                              })
                            ],
                          ),
                          title: Text(
                              '${friendListController.friendListResponse.value.response![index].name}'),
                          onTap: () {
                            friendListController.friendListResponse.value
                                    .response![index].groupid.isNotEmpty
                                ? showAlreadyInGroupDialog(context)
                                : friendListController.addFriend(
                                    context,
                                    friendListController.friendListResponse
                                        .value.response![index].userid,
                                    groupId);
                          },
                          trailing: friendListController.friendListResponse
                                      .value.response![index].groupid ==
                                  null
                              ? Icon(Icons.add)
                              : Text("."),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
          Positioned(
              child: Obx(() => friendListController.addFriendLoading.value
                  ? LoadingWidget()
                  : SizedBox.shrink()))
        ],
      ),
    );
  }
}
