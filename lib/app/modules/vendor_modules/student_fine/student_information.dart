import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/clase_wise_order/class_wise_order_controller.dart';

import 'package:connect_canteen/app/modules/vendor_modules/student_fine/fine_controller.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';

import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class StudnetInformationPage extends StatelessWidget {
  final OrderResponse order;
  StudnetInformationPage({super.key, required this.order});
  final fineController = Get.put(StudnetFineController());
  final classWiseOrderController = Get.put(ClassWiseOrderController());

  Future<void> _refreshData() async {
    // Fetch data based on the selected category
    await Future.delayed(Duration(seconds: 0));
    fineController.fetchUserData(order.cid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black, // Assuming you have defined AppStyles.appbar
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            classWiseOrderController.fetchOrders();
            Get.back();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Container(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Obx(() {
                    if (fineController.isFetchLoading.value) {
                      return const Center(child: LoadingScreen());
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70.0,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: CachedNetworkImageProvider(
                              fineController.userDataResponse.value.response!
                                      .first.profilePicture ??
                                  '',
                            ),
                            child: fineController.userDataResponse.value
                                        .response!.first.profilePicture ==
                                    null
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 16.0),
                          Obx(() => Text(
                                fineController.userDataResponse.value.response!
                                    .first.name,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          SizedBox(height: 8.0),
                          Text(
                            fineController
                                .userDataResponse.value.response!.first.classes,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoItem(
                                  "Student Score",
                                  fineController.userDataResponse.value
                                      .response!.first.studentScore
                                      .toString()),
                              _buildInfoItem("Fine Amount",
                                  "Rs.${fineController.userDataResponse.value.response!.first.fineAmount.toString()}"),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          fineController.userDataResponse.value.response!.first
                                      .studentScore ==
                                  0
                              ? Container(
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.yellow[100], // Background color
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Rounded corners
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.warning, // Icon for warning
                                        color: Colors.red, // Warning color
                                        size: 40.0, // Icon size
                                      ),
                                      SizedBox(
                                          width:
                                              16.0), // Spacing between icon and text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Penalty', // Title
                                              style: TextStyle(
                                                fontSize:
                                                    20.0, // Title font size
                                                fontWeight: FontWeight
                                                    .bold, // Title font weight
                                                color:
                                                    Colors.red, // Title color
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    8.0), // Vertical spacing
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'The student have to pay fine of 10%', // Message
                                                  style: TextStyle(
                                                    fontSize:
                                                        16.0, // Message font size
                                                    color: Colors
                                                        .black, // Message color
                                                  ),
                                                ),
                                                Text(
                                                  'Total fine : Rs ${((0.1 * order.price).toInt())}', // Message
                                                  style: TextStyle(
                                                    fontSize:
                                                        16.0, // Message font size
                                                    color: Colors
                                                        .black, // Message color
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
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
                                      color: Colors
                                          .white, // Add a background color
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          fineController.fineApply.value
                              ? Container()
                              : Obx(() => CustomButton(
                                  text: 'Hold the order',
                                  onPressed: () {
                                    fineController
                                        .stateUpdate(
                                            context,
                                            order.id,
                                            order.cid,
                                            fineController
                                                .userDataResponse
                                                .value
                                                .response!
                                                .first
                                                .fineAmount,
                                            fineController
                                                        .userDataResponse
                                                        .value
                                                        .response!
                                                        .first
                                                        .studentScore ==
                                                    0
                                                ? (0.1 * order.price).toInt()
                                                : 0,
                                            fineController
                                                .userDataResponse
                                                .value
                                                .response!
                                                .first
                                                .studentScore)
                                        .then((value) {
                                      fineController.fineApply(true);
                                      showDialog(
                                          barrierColor:
                                              Color.fromARGB(255, 73, 72, 72)
                                                  .withOpacity(0.5),
                                          context: Get.context!,
                                          builder: (BuildContext context) {
                                            return CustomPopup(
                                              message:
                                                  'Succesfully  Hold Orders ',
                                              onBack: () {
                                                Get.back();
                                              },
                                            );
                                          });
                                    });
                                    ;
                                  },
                                  isLoading: fineController.loading.value))
                        ],
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
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
}
