import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/student_modules/friend_list/friend_list.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/new_grou.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupPage extends StatelessWidget {
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

  final List<Map<String, String>> groupMembers = [
    {
      'name': 'John Doe',
      'phone': '123-456-7890',
      'image':
          'https://media.licdn.com/dms/image/D5603AQGhPbKvmTZvEA/profile-displayphoto-shrink_200_200/0/1684915342511?e=1721865600&v=beta&t=e6pJHiFAd5WeBgrhyJggmanb0CXRt7tlKlKpTq1qUz0',
    },
    {
      'name': 'Jane Smith',
      'phone': '987-654-3210',
      'image':
          'https://media.licdn.com/dms/image/D5603AQGhPbKvmTZvEA/profile-displayphoto-shrink_200_200/0/1684915342511?e=1721865600&v=beta&t=e6pJHiFAd5WeBgrhyJggmanb0CXRt7tlKlKpTq1qUz0',
    },
    {
      'name': 'Michael Brown',
      'phone': '555-555-5555',
      'image':
          'https://media.licdn.com/dms/image/D5603AQGhPbKvmTZvEA/profile-displayphoto-shrink_200_200/0/1684915342511?e=1721865600&v=beta&t=e6pJHiFAd5WeBgrhyJggmanb0CXRt7tlKlKpTq1qUz0',
    },
  ];
  bool isgroupcreate = true;
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
        child: isgroupcreate
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF5D56F4),
                          Color(0xFF69B4FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Group Name: Flutter Group',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Group Code: 100',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupMembers.length,
                      itemBuilder: (context, index) {
                        final member = groupMembers[index];
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
                                  child: CachedNetworkImage(
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
                                    imageUrl: member['image'] ?? '',
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
                              1 == 1
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        radius: 7.5,
                                        backgroundColor: Color.fromARGB(255, 72,
                                            2, 129), // Adjust color as needed
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
                            member['name']!,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            member['phone']!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Start your group or join in a group",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        'Start ordering food in a group.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => NewGroup());
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                "Start",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: isgroupcreate
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => FriendsPage());
                // Add friend action
              },
              backgroundColor: Color.fromARGB(221, 4, 22, 137),
              child: Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
