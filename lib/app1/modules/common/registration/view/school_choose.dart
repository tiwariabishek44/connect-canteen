import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/common/registration/registration_controller.dart';
import 'package:connect_canteen/app1/modules/common/registration/view/registration_view.dart';
import 'package:connect_canteen/app1/widget/welcome_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class SchoolChoose extends StatelessWidget {
  SchoolChoose({Key? key}) : super(key: key);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final registerController = Get.put(UserRegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeHeading(
                mainHeading: "Choose your School/College", subHeading: ""),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(ApiEndpoints.productionSchoolcollection)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8.0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Container(
                                  height:
                                      20.0, // Adjust the height of the title container
                                  color: Colors.grey[
                                      200], // Light grey color for shimmer effect
                                ),
                                subtitle: Container(
                                  height:
                                      16.0, // Adjust the height of the subtitle container
                                  color: Colors.grey[
                                      200], // Light grey color for shimmer effect
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final schools = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: schools.length,
                    itemBuilder: (context, index) {
                      final schoolData =
                          schools[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          registerController.schoolname.value =
                              schoolData["name"];
                
                          Get.off(() => RegisterView(
                                schoolname: schoolData["name"],
                                schoolId: schoolData["schoolId"],
                              ));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Container(
                            padding: EdgeInsets.all(2.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8.0,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                schoolData["name"] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp),
                              ),
                              subtitle: Text(
                                schoolData["address"] ?? '',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey[600]),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
