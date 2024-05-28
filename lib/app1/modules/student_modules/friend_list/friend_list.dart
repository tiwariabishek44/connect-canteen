import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FriendsPage extends StatelessWidget {
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

  final List<Map<String, String>> students = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Friend List',
          style: TextStyle(
            color: Color.fromARGB(255, 246, 244, 244),
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
        padding: EdgeInsets.only(top: 2.h),
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
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
                            (context, url, downloadProgress) => CircleAvatar(
                          radius: 21.4.sp,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 224, 218, 218),
                        ),
                        imageUrl: student['image'] ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Apply circular shape
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        errorWidget: (context, url, error) => CircleAvatar(
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
                  Positioned(
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
                ],
              ),
              title: Text(
                student['name']!,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                student['phone']!,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                showAlreadyInGroupDialog(context);
                // Navigate to student details page or perform any action on tap
              },
            );
          },
        ),
      ),
    );
  }
}
