import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group.dart';
import 'package:connect_canteen/app1/modules/common/wallet/wallet_page.dart';
import 'package:connect_canteen/app1/widget/logout_cornfiration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/widget/profile_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatelessWidget {
  final loignController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Column(children: [
            Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 8.h, bottom: 3.h, right: 4.w, left: 4.w),
                  child: StreamBuilder<StudentDataResponse?>(
                      stream: loignController.getStudetnData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return SizedBox.shrink();
                        } else if (snapshot.data == null) {
                          return SizedBox.shrink();
                        } else {
                          StudentDataResponse studetnData = snapshot.data!;

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Container(
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
                                          radius: 31.sp,
                                          backgroundColor: Colors.white,
                                          child: studetnData.profilePicture ==
                                                  ''
                                              ? CircleAvatar(
                                                  radius: 21.4.sp,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 224, 218, 218),
                                                )
                                              : CachedNetworkImage(
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Opacity(
                                                    opacity: 0.8,
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.black12,
                                                      highlightColor:
                                                          Colors.red,
                                                      child: Container(),
                                                    ),
                                                  ),
                                                  imageUrl: studetnData
                                                          .profilePicture ??
                                                      '',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
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
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    radius: 21.4.sp,
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 224, 218, 218),
                                                  ),
                                                )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${studetnData.name}",
                                        style: AppStyles.listTileTitle,
                                      ),
                                      Text(
                                        "${studetnData.classes}",
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 78, 78, 78)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.phone,
                                      color: Color.fromARGB(255, 78, 78, 78)),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    '${studetnData.phone}',
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 78, 78, 78)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.email,
                                      color: Color.fromARGB(255, 78, 78, 78)),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    '${studetnData.email}',
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 78, 78, 78)),
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                      })),
            ),
            Divider(
              height: 0.4.h,
              thickness: 0.4.h,
              color: Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
            ),
            SizedBox(
              height: 2.h,
            ),
            ProfileTile(
              onTap: () {
                Get.to(
                    () => WalletPage(
                          userId: 'this is the user id file 1',
                          isStudent: true,
                          name: 'Abishek Tiwari',
                          image:
                              'https://res.cloudinary.com/dndtiooiy/image/upload/v1694107077/jcqp06eon60nd99g5i4v.png',
                        ),
                    transition: Transition.cupertino,
                    duration: duration);
              },
              title: "Wallet",
              leadingIcon: const Icon(Icons.wallet),
            ),
            ProfileTile(
              onTap: () {
                Get.to(() => GroupPage(),
                    transition: Transition.cupertino, duration: duration);
              },
              title: "Groups",
              leadingIcon: const Icon(Icons.group),
            ),
            ProfileTile(
              onTap: () {},
              title: "Order History",
              leadingIcon: const Icon(Icons.shopping_cart_checkout_sharp),
            ),
            ProfileTile(
              onTap: () {},
              title: "Order Holds ",
              leadingIcon: const Icon(Icons.stop_circle_outlined),
            ),
            ProfileTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LogoutConfirmationDialog(
                      isbutton: true,
                      heading: 'Alert',
                      subheading: "Do you want to logout of the application?",
                      firstbutton: "Yes",
                      secondbutton: 'No',
                      onConfirm: () {
                        loignController.logout();
                      },
                    );
                  },
                );
              },
              title: "Logout",
              leadingIcon: const Icon(
                Icons.logout,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
