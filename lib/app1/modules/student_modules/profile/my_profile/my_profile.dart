import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/profile/my_profile/student_fine_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final fineController = Get.put(FineController());
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        physics: AlwaysScrollableScrollPhysics(),
        child: Obx(() {
          if (loginController.isFetchLoading.value) {
            return const LoadingWidget();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileAvatar(),
                SizedBox(height: 16.0),
                _buildUserName(),
                SizedBox(height: 8.0),
                _buildUserClass(),
                SizedBox(height: 16.0),
                _buildUserStats(),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 70.0,
      backgroundColor: Colors.grey[300],
      backgroundImage: CachedNetworkImageProvider(
        loginController.userDataResponse.value.response!.first.profilePicture ??
            '',
      ),
      child: loginController
                  .userDataResponse.value.response!.first.profilePicture ==
              null
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildUserName() {
    return Obx(
      () => Text(
        loginController.userDataResponse.value.response!.first.name,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildUserClass() {
    return Obx(
      () => Text(
        loginController.userDataResponse.value.response!.first.classes,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return Obx(() => Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWalletItem(
                icon: Icons.account_balance_wallet,
                title: 'Balance Amount',
                value: loginController
                    .userDataResponse.value.response!.first.studentScore
                    .toString(),
                color: Colors.green,
              ),
              _buildWalletItem(
                icon: Icons.money,
                title: 'Fine Pay',
                value: loginController
                    .userDataResponse.value.response!.first.fineAmount
                    .toString(),
                color: Colors.red,
              ),
            ],
          ),
        ));
  }

  Widget _buildWalletItem(
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                Text(
                  "Rs." + value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
