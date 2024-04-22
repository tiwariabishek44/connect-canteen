import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/profile/my_profile/student_fine_controller.dart';
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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        scrolledUnderElevation: 0,
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fineController.refreshData,
        child: Stack(
          children: [
            SingleChildScrollView(
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
                      Obx(() {
                        if (fineController.orderLoded.value) {
                          return GestureDetector(
                            onTap: () {
                              final coins = (fineController
                                      .orderResponse.value.response!.length *
                                  10);
                              fineController
                                  .collectCoin(
                                      loginController.userDataResponse.value
                                          .response!.first.userid,
                                      coins)
                                  .then((value) => showDialog(
                                      barrierColor:
                                          Color.fromARGB(255, 73, 72, 72)
                                              .withOpacity(0.5),
                                      context: Get.context!,
                                      builder: (BuildContext context) {
                                        return CustomPopup(
                                          message: 'Coin Collect Succesfully',
                                          onBack: () {
                                            Get.back();
                                          },
                                        );
                                      }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 219, 205, 13),
                              ),
                              height: 8.h,
                              width: 70.w,
                              child: Center(
                                  child: Text(
                                      "Claim ${fineController.orderResponse.value.response!.length * 10}")),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                      SizedBox(
                        height: 1.h,
                      ),
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
            Obx(
              () => fineController.finePayment.value
                  ? Positioned(
                      top: 40.h,
                      left: 35.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,

                          borderRadius: BorderRadius.circular(
                              20), // Adjust the border radius here
                        ),
                        height: 15.h,
                        width: 30.w,
                        child: SpinKitCircle(
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
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
    return Container(
      height: 15.h,
      color: Color.fromARGB(255, 255, 255, 255), // Grey color with transparency
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0.h),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loginController
                            .userDataResponse.value.response!.first.studentScore
                            .toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Student Score',
                        style: AppStyles.listTilesubTitle,
                      ),
                    ],
                  ),
                ),
                // Adjust height or add child widget as needed
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Container(
                // Container 2
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loginController
                            .userDataResponse.value.response!.first.fineAmount
                            .toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Fine Amount',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Container(
                // Container 3
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loginController
                            .userDataResponse.value.response!.first.miCoin
                            .toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'miCoins',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(2, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
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
              color: Color(0xff06C167),
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFineList() {
    final sortedFines = fineController.getFineResponse.value.response!
      ..sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedFines.map((fine) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(2, 2))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fine.date,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Rs. ${fine.fineAmount}",
                style: TextStyle(
                  fontSize: 16,
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
        color: Color(0xff06C167),
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
