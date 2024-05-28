import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/modules/common/login/login_page.dart';
import 'package:connect_canteen/app/modules/common/loginoption/login_option_controller.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginOptionView extends StatefulWidget {
  @override
  State<LoginOptionView> createState() => _LoginOptionViewState();
}

class _LoginOptionViewState extends State<LoginOptionView> {
  final loginOptionController = Get.put(LoginScreenController());

  Future<String>? permissionStatusFuture;
  bool showPopup = false;

  @override
  void initState() {
    super.initState();

    // Check initial connectivity status
    // permissionStatusFuture = getCheckNotificationPermStatus();
  }

  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";
  // Future<String> getCheckNotificationPermStatus() {
  //   return NotificationPermissions.getNotificationPermissionStatus()
  //       .then((status) {
  //     switch (status) {
  //       case PermissionStatus.denied:
  //         return permDenied;
  //       case PermissionStatus.granted:
  //         return permGranted;
  //       case PermissionStatus.unknown:
  //         return permUnknown;
  //       case PermissionStatus.provisional:
  //         return permProvisional;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  child: Image.asset(
                    'assets/splash1.png',
                    fit: BoxFit.cover,
                  ),
                  height: 30.h,
                  width: 100.w,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 2.h),
                  child: Column(
                    children: [
                      Text(
                        'Continue as:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomButton(
                          text: 'Continue As Student',
                          onPressed: () {
                            loginOptionController.isUser.value = true;
                            Get.to(() => LoginScreen(),
                                transition: Transition.rightToLeft);
                          },
                          isLoading: false),
                      SizedBox(height: 0.6.h),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(255, 97, 96, 96),
                              height: 0.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Text(
                              'OR',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(255, 97, 96, 96),
                              height: 0.5,
                            ),
                          ),
                        ],
                      ),
                      CustomButton(
                          text: 'Continue As Canteen',
                          onPressed: () {
                            loginOptionController.isUser.value = false;
                            Get.to(() => LoginScreen(),
                                transition: Transition.rightToLeft);
                          },
                          isLoading: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 49.h,
          //   left: 10,
          //   right: 10,
          //   child: FutureBuilder(
          //     future: permissionStatusFuture,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return CircularProgressIndicator();
          //       }

          //       if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       }

          //       if (snapshot.hasData) {
          //         if (snapshot.data == permGranted) {
          //           return Text(
          //             "The permission status is ${snapshot.data}",
          //             style: TextStyle(fontSize: 20),
          //             textAlign: TextAlign.center,
          //           );
          //         } else {
          //           if (showPopup) {
          //             return Container(
          //               decoration: BoxDecoration(color: Colors.white),
          //               child: AlertDialog(
          //                 contentPadding: EdgeInsets
          //                     .zero, // Remove gap between container border and alert dialog border
          //                 scrollable: false,
          //                 title: Text(
          //                   "Notification Permission Required",
          //                   style: AppStyles.appbar,
          //                 ),
          //                 actions: [
          //                   Divider(
          //                     height: 1,
          //                     thickness: 1,
          //                     color: const Color.fromARGB(255, 171, 173, 171),
          //                   ),
          //                   SizedBox(
          //                     height: 1.h,
          //                   ),
          //                   Center(
          //                       child: GestureDetector(
          //                     onTap: () {
          //                       NotificationPermissions
          //                           .requestNotificationPermissions(
          //                         iosSettings: const NotificationSettingsIos(
          //                           sound: true,
          //                           badge: true,
          //                           alert: true,
          //                         ),
          //                       ).then((_) {
          //                         setState(() {
          //                           showPopup = false;
          //                           permissionStatusFuture =
          //                               getCheckNotificationPermStatus();
          //                         });
          //                       });
          //                     },
          //                     child: Text(
          //                       " Grant Permission",
          //                       style: TextStyle(
          //                           color: Colors.blue,
          //                           fontSize: 19.sp,
          //                           fontWeight: FontWeight.bold),
          //                     ),
          //                   )),
          //                 ],
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(10.0),
          //                 ),
          //                 elevation: 0.0,
          //               ),
          //             );
          //           } else {
          //             return Container();
          //           }
          //         }
          //       }

          //       return Text("No permission status yet");
          //     },
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    permissionStatusFuture?.then((value) {
      if (value != permGranted) {
        setState(() {
          showPopup = true;
        });
      }
    });
  }
}
