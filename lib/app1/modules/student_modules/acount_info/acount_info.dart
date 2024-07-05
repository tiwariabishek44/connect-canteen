import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/account_info_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/class_update.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/name_update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({super.key});
  final accountInfoController = Get.put(AccountInfoController());
  final loignController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text("User Accounts"),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Account Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: StreamBuilder<StudentDataResponse?>(
          stream: loignController.getStudetnData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return SizedBox.shrink();
            } else if (snapshot.data == null) {
              return Center();
            } else {
              StudentDataResponse studetnData = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stack(
                  //   children: [
                  //     CircleAvatar(
                  //       radius: 34.sp,
                  //       backgroundColor: Colors.white,
                  //       child: studetnData.profilePicture == ''
                  //           ? CircleAvatar(
                  //               radius: 34.sp,
                  //               backgroundColor:
                  //                   const Color.fromARGB(255, 236, 230, 230),
                  //               child: Icon(
                  //                 Icons.person,
                  //                 size: 38.sp,
                  //                 color: Colors.grey,
                  //               ),
                  //             )
                  //           : CachedNetworkImage(
                  //               progressIndicatorBuilder:
                  //                   (context, url, downloadProgress) => Opacity(
                  //                 opacity: 0.8,
                  //                 child: Shimmer.fromColors(
                  //                   baseColor: const Color.fromARGB(
                  //                       255, 248, 246, 246),
                  //                   highlightColor:
                  //                       Color.fromARGB(255, 238, 230, 230),
                  //                   child: Container(
                  //                     decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(50),
                  //                       color:
                  //                           Color.fromARGB(255, 161, 157, 157),
                  //                     ),
                  //                     width: 14.h,
                  //                     height: 14.h,
                  //                   ),
                  //                 ),
                  //               ),
                  //               imageUrl: studetnData.profilePicture,
                  //               imageBuilder: (context, imageProvider) =>
                  //                   Container(
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   image: DecorationImage(
                  //                     image: imageProvider,
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                 ),
                  //               ),
                  //               errorWidget: (context, url, error) => Icon(
                  //                 Icons.person,
                  //                 color: Colors.grey,
                  //               ),
                  //             ),
                  //     ),
                  //     Positioned(
                  //       bottom: 10.sp,
                  //       right: 16,
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           showDialog(
                  //             context: context,
                  //             builder: (BuildContext context) {
                  //               return PhotoPermission(
                  //                 studentId: studetnData.userid,
                  //               );
                  //             },
                  //           );
                  //         },
                  //         child: CircleAvatar(
                  //           backgroundColor:
                  //               const Color.fromARGB(255, 235, 232, 232),
                  //           radius: 20.sp,
                  //           child: Icon(
                  //             Icons.edit,
                  //             size: 20.0.sp,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                  // Text(
                  //   " Basic info",
                  //   style:
                  //       TextStyle(fontWeight: FontWeight.w800, fontSize: 19.sp),
                  // ),
                  SizedBox(
                    height: 1.h,
                  ),
                  buildCustomListTile(
                      istick: false,
                      onTap: () {
                        Get.to(
                            () => NameUpdate(
                                  userId: studetnData.userid,
                                  initialName: loignController
                                      .studentDataResponse.value!.name,
                                ),
                            transition: Transition.cupertinoDialog);
                      },
                      title: 'Name ',
                      subtitle: studetnData.name,
                      trailing: Icons.chevron_right),
                  StreamBuilder<List<String>>(
                    stream: accountInfoController
                        .getClassNames("texasinternationalcollege"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        return SizedBox.shrink();
                      } else {
                        List<String> classNames = snapshot.data ?? [];

                        return buildCustomListTile(
                            istick: false,
                            onTap: () {
                              Get.to(
                                  () => ClassUpdate(
                                        userId: studetnData.userid,
                                        initialName: studetnData.classes,
                                        classOptions: classNames,
                                      ),
                                  transition: Transition.cupertinoDialog);
                            },
                            title: 'Class ',
                            subtitle: studetnData.classes,
                            trailing: Icons.chevron_right);
                      }
                    },
                  ),
                  buildCustomListTile(
                      onTap: () {},
                      istick: true,
                      title: 'Phone number ',
                      subtitle: studetnData.phone,
                      trailing: Icons.chevron_right),
                  buildCustomListTile(
                      istick: true,
                      onTap: () {},
                      title: 'Email ',
                      subtitle: studetnData.email,
                      trailing: Icons.chevron_right)
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildCustomListTile({
    required String title,
    required String subtitle,
    required IconData trailing,
    required VoidCallback onTap,
    required bool istick,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 19.sp, color: Colors.black),
      ),
      subtitle: Row(
        children: [
          Text(
            subtitle,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                color: Colors.grey[700]),
          ),
          SizedBox(
            width: 5.w,
          ),
          istick
              ? CircleAvatar(
                  radius: 7.5,
                  backgroundColor:
                      Color.fromARGB(255, 0, 0, 0), // Adjust color as needed
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 9,
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
      trailing: Icon(
        trailing,
        color: Colors.grey[700],
      ),
      onTap: onTap,
    );
  }
}
