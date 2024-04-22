import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/meal%20overflow/overflow_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/list_tile_contailer.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:connect_canteen/app/widget/no_data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OverflowMarkAsReadPage extends StatelessWidget {
  OverflowMarkAsReadPage({super.key});

  final overflowController = Get.put(OverflowController());
  var overflowMarkedAsRead = false.obs; // Track overflow orders marked as read

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'OverFlow ',
        iconrequired: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Obx(() => Text(
                    "OverFlow OF  :  ${overflowController.overflowMealTime.value}",
                    style: AppStyles.titleStyle,
                  )),
              SizedBox(
                height: 2.h,
              ),
              Obx(() {
                if (overflowMarkedAsRead.value) {
                  return FutureBuilder<List<OverflowOrder>>(
                    future: overflowController.fetchOverflowOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: NoDataWidget(
                            message: 'There is no overflow remaining',
                            iconData: Icons.check_circle_outline,
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final overflowOrder = snapshot.data![index];
                                return ListTileContainer(
                                  name: overflowOrder.overflowOrderName,
                                  quantit: overflowOrder.quantity,
                                );
                              },
                            ),
                            SizedBox(height: 3.h),
                            CustomButton(
                              text: 'Marked As Read',
                              onPressed: () async {
                                await overflowController.markAsRead();
                                overflowMarkedAsRead.value =
                                    true; // Update state
                              },
                              isLoading: false,
                            )
                          ],
                        );
                      }
                    },
                  );
                } else {
                  return FutureBuilder<List<OverflowOrder>>(
                    future: overflowController.fetchOverflowOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: NoDataWidget(
                            message: 'There is no overflow remaining',
                            iconData: Icons.check_circle_outline,
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final overflowOrder = snapshot.data![index];
                                return ListTileContainer(
                                  name: overflowOrder.overflowOrderName,
                                  quantit: overflowOrder.quantity,
                                );
                              },
                            ),
                            SizedBox(height: 3.h),
                            CustomButton(
                              text: 'Marked As Read',
                              onPressed: () async {
                                await overflowController.markAsRead();
                                overflowMarkedAsRead.value =
                                    true; // Update state
                              },
                              isLoading: false,
                            )
                          ],
                        );
                      }
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
