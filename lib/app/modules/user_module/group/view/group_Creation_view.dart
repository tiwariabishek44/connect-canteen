import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/modules/user_module/group/group_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupCreation extends StatelessWidget {
  final GroupController groupController = Get.put(GroupController());

  void _showGroupNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Group Name'),
          content: TextField(
            controller: groupController.groupnameController,
            decoration: InputDecoration(
              hintText: 'Type the group name...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            GestureDetector(
              onTap: () {
                groupController.createNewGroup();

                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(12.0),
                child: const Text(
                  "Create",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                'Make the food order in a group.',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      // Show dialog for entering group name
                      _showGroupNameDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: const Text(
                        "    Start    ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (groupController.startNewGroup.value) {
                return Container(
                  height: 50.h,
                  width: 90.w,
                  color: Colors.amber,
                );
              } else {
                return SizedBox();
              }
            })
          ],
        ),
        Obx(() {
          if (groupController.isloading.value) {
            return Positioned(
                left: 40.w,
                height: 50.h,
                child: Center(
                  child: LoadingWidget(),
                ));
          } else {
            return SizedBox(); // Return an empty container if not loading
          }
        }),
      ],
    );
  }
}
