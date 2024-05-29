import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupDataField extends StatelessWidget {
  GroupDataField({super.key, required this.groupid});
  final String groupid;
  final groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StudentGroupApiResponse?>(
      stream: groupController.getGroupData(groupid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return SizedBox.shrink();
        } else if (snapshot.data == null) {
          return Container();
        } else {
          StudentGroupApiResponse groupData = snapshot.data!;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 237, 240, 240),
                  Color.fromARGB(255, 223, 224, 223)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(66, 109, 109, 109),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet BALANCE',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(179, 60, 58, 58),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '\NPR 100.00',
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 17, 17, 17),
                  ),
                ),
              ],
            ),
          );

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
                  'Group Name:${groupData.groupName}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Group Code:${groupData.groupCode}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
