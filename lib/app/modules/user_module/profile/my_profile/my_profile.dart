import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/user_module/profile/my_profile/student_fine_controller.dart';
import 'package:connect_canteen/app/eSewa/esewa_function.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final fineController = Get.put(FineController());

  final loginController = Get.put(LoginController());

  late final FineEsewaPay finpay;

  @override
  void initState() {
    super.initState();
    // Initialize FineEsewaPay with FineController instance
    finpay = FineEsewaPay(FineController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fineController.refreshData,
        child: SingleChildScrollView(
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
                  SizedBox(height: 16.0),
                  _buildPayButton(context),
                  SizedBox(height: 16.0),
                  _buildFinesSection(),
                ],
              );
            }
          }),
        ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(
          "Student Score",
          loginController.userDataResponse.value.response!.first.studentScore
              .toString(),
        ),
        _buildInfoItem(
          "Fine Amount",
          "Rs.${loginController.userDataResponse.value.response!.first.fineAmount.toString()}",
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return Obx(
      () =>
          loginController.userDataResponse.value.response!.first.fineAmount != 0
              ? CustomButton(
                  text: 'Pay',
                  onPressed: () {
                    finpay.finPay(
                      context,
                      studentId: loginController
                          .userDataResponse.value.response!.first.userid,
                      fineAmount: loginController
                          .userDataResponse.value.response!.first.fineAmount,
                    );
                  },
                  isLoading: fineController.loading.value,
                )
              : SizedBox(),
    );
  }

  Widget _buildFinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Fines Pay:",
          style: AppStyles.topicsHeading,
        ),
        SizedBox(height: 16.0),
        Obx(() {
          if (fineController.fineLoading.value) {
            return _buildLoadingFines();
          } else {
            return fineController.fineLoaded.value
                ? _buildFineList()
                : _buildNoFinesInfo();
          }
        }),
      ],
    );
  }

  Widget _buildLoadingFines() {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 209, 204, 204)!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.0),
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFineList() {
    final sortedFines = fineController.studentFinesResponse.value.response!
      ..sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedFines.map((fine) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50), // Green color for background
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fine.date,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Rs. ${fine.fineAmount}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoFinesInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          SizedBox(width: 8.0),
          Text(
            "You haven't incurred any fines up to this point.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  DateTime _parseDate(String date) {
    List<String> parts = date.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
}
