import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/models/wallet_model.dart';
import 'package:connect_canteen/app/modules/common/wallet/controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/vendor_modules/penalty/clase_wise_order/class_wise_order_controller.dart';

import 'package:connect_canteen/app/modules/vendor_modules/student_fine/fine_controller.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';

import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class StudnetInformationPage extends StatelessWidget {
  final OrderResponse order;

  final String date;
  StudnetInformationPage({super.key, required this.order, required this.date});
  final fineController = Get.put(StudnetFineController());
  final classWiseOrderController = Get.put(ClassWiseOrderController());

  Future<void> _refreshData() async {
    // Fetch data based on the selected category
    await Future.delayed(Duration(seconds: 0));
    fineController.fetchUserData(order.cid);
  }

  final WalletController walletController = Get.put(WalletController());

  String truncateName(String name, {int maxLength = 10}) {
    if (name.length <= maxLength) return name;
    return '${name.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black, // Assuming you have defined AppStyles.appbar
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            classWiseOrderController.fetchOrders(date);
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(66, 178, 176, 176),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.customer}! 👋', // Use truncated name
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'April 20, 2024', // Replace with current date
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
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
                        radius: 22.sp,
                        backgroundColor: Colors.white,
                        child: CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => CircleAvatar(
                            radius: 21.4.sp,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 224, 218, 218),
                          ),
                          imageUrl: order.customerImage ?? '',
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
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 100.w,
              height: 15.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(66, 178, 176, 176),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 2.h, left: 5.w),
                child: StreamBuilder<Wallet?>(
                  stream: walletController.getWallet(order.cid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingWidget();
                    } else if (snapshot.hasError) {
                      return SizedBox.shrink();
                    } else if (snapshot.data == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\Rs.0', // Display total balance
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Wallet BALANCE',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    } else {
                      Wallet wallet = snapshot.data!;
                      Map<String, double> totals =
                          walletController.calculateTotals(wallet.transactions);
                      double totalBalance = totals['totalBalance'] ?? 0.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\Rs.${totalBalance.toInt()}', // Display total balance
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Wallet BALANCE',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.0.h),
              child: Container(
                height: 17.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white, // Add a background color
                      ),
                      height: 15.h,
                      width: 30.w,
                      child: ClipRRect(
                        // Use ClipRRect to ensure that the curved corners are applied
                        borderRadius: BorderRadius.circular(7),
                        child: CachedNetworkImage(
                          imageUrl: order.productImage ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline, size: 40),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.listTileTitle,
                          ),
                          Text(
                            'Rs.${order.price}',
                            style: AppStyles.listTilesubTitle,
                          ),
                          Text(order.customer,
                              style: AppStyles.listTilesubTitle),
                          Text(
                            order.date,
                            style: AppStyles.listTilesubTitle,
                          ),
                          Text(order.orderTime,
                              style: AppStyles.listTilesubTitle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: Colors.redAccent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.redAccent,
                    size: 30.sp,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'A 20% fine (Rs.${(0.2 * order.price).toInt()}) will be applied to the student\'s balance.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => fineController.fineApply.value
                ? Container()
                : Obx(() => CustomButton(
                    text: 'Hold the order',
                    onPressed: () {
                      DateTime now = DateTime.now();
                      NepaliDateTime nepaliDateTime =
                          NepaliDateTime.fromDateTime(now);
                      fineController.stateUpdate(context, order.id);
                      walletController
                          .addTransaction(
                        order.cid,
                        Transactions(
                          date: nepaliDateTime,
                          name: 'penalty', // or penalty
                          amount: (0.2 * order.price),
                          remarks: "",
                        ),
                      )
                          .then((value) {
                        fineController.fineApply(true);
                        showDialog(
                            barrierColor: Color.fromARGB(255, 73, 72, 72)
                                .withOpacity(0.5),
                            context: Get.context!,
                            builder: (BuildContext context) {
                              return CustomPopup(
                                message: 'Succesfully  Hold Orders ',
                                onBack: () {
                                  Get.back();
                                },
                              );
                            });
                      });
                    },
                    isLoading: fineController.loading.value)))
          ],
        ),
      ),
    );
  }
}
