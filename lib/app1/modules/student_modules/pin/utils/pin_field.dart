import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/group_data_shrimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PinField extends StatelessWidget {
  PinField({super.key, required this.groupid});
  final String groupid;
  final groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StudentGroupApiResponse?>(
      stream: groupController.getGroupData(groupid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GroupFieldShrimmer();
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
                  groupData.groupName,
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(179, 60, 58, 58),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Pin:${groupData.groupCode}',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 17, 17, 17),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
