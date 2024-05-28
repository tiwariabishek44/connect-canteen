import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/models/wallet_model.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/common/wallet/controller.dart';
import 'package:connect_canteen/app/modules/common/wallet/page.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final logincontroller = Get.put(LoginController());
  final WalletController walletController = Get.put(WalletController());

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final date = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(66, 178, 176, 176),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        if (logincontroller.isFetchLoading.value) {
          return LoadingWidget();
        } else {
          String fullName =
              logincontroller.userDataResponse.value.response!.first.name;
          String firstName = fullName.split(' ').first;

          return GestureDetector(
            onTap: () {
              Get.to(() => WalletPage(
                  userId: logincontroller
                      .userDataResponse.value.response!.first.userid,
                  isStudent: true,
                  name: logincontroller
                      .userDataResponse.value.response!.first.name,
                  image: logincontroller
                      .userDataResponse.value.response!.first.profilePicture));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, $firstName! 👋',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 134, 29, 29),
                        ),
                        child: CircleAvatar(
                          radius: 21.sp,
                          backgroundColor: Colors.white,
                          child: CachedNetworkImage(
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Opacity(
                              opacity: 0.8,
                              child: Shimmer.fromColors(
                                baseColor: Colors.black12,
                                highlightColor: Colors.red,
                                child: Container(),
                              ),
                            ),
                            imageUrl: logincontroller.userDataResponse.value
                                    .response!.first.profilePicture ??
                                '',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // Apply circular shape
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            fit: BoxFit.fill,
                            width: double.infinity,
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 21.4.sp,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 218, 218),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),

                  // Balance
                  StreamBuilder<Wallet?>(
                    stream: walletController.getWallet(logincontroller
                        .userDataResponse.value.response!.first.userid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return SizedBox.shrink();
                      } else {
                        Wallet wallet = snapshot.data!;
                        Map<String, double> totals = walletController
                            .calculateTotals(wallet.transactions);
                        double totalBalance = totals['totalBalance'] ?? 0.0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\Rs.${totalBalance}',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'ACCOUNT BALANCE',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
