import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/vendor_modules/menue/view/menue_view.dart';
import 'package:connect_canteen/app_test/data%20_print_page.dart';
import 'package:connect_canteen/app_test/test_contorller%20.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';

import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/style.dart';

import 'package:connect_canteen/app/modules/vendor_modules/analytics/view/analytics_page.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/view/class_wise_analysis.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/view/order_cancel.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/demand_supply.dart';
import 'package:connect_canteen/app/modules/vendor_modules/order_requirements/view/order_requirement_view.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_checkout/orders_screen.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../app_test/test_page.dart';

class DshBoard extends StatelessWidget {
  final salseContorlller = Get.put(SalsesController());
  final printController = Get.put(PrintController());
  final testcontorller = Get.put(TestContorller());
  @override
  Widget build(BuildContext context) {
    salseContorlller.fetchTotalOrder();
    salseContorlller.fetchTotalSales();
    DateTime currentDate = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

    return Scaffold(
      backgroundColor: AppColors.greyColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: AppStyles.appbar,
              ),
              Text(
                formattedDate, // Display Nepali date in the app bar
                style: AppStyles.listTilesubTitle,
              ),
            ],
          ),
        ),
      ),
      // Add the rest of your app content here

      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Quick Summary",
                  style: AppStyles.mainHeading,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the value for the desired curve
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 189, 187, 187).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0,
                          2), // Adjust the values to control the shadow appearance
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 197, 195, 195)),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 1.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Order',
                                    style: AppStyles.listTileTitle,
                                  ),
                                  // Add spacing between the texts
                                  Text(
                                    "Rs. " +
                                        salseContorlller
                                            .totalorderGRandTotal.value
                                            .toInt()
                                            .toString(),
                                    style: AppStyles.topicsHeading,
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Obx(() => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 197, 195, 195)),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 1.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Sales',
                                    style: AppStyles.listTileTitle,
                                  ),
                                  Text(
                                    "Rs. " +
                                        salseContorlller.grandTotal.value
                                            .toInt()
                                            .toString(),
                                    style: AppStyles.topicsHeading,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the value for the desired curve
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 189, 187, 187).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0,
                          2), // Adjust the values to control the shadow appearance
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Manager Activity",
                          style: AppStyles.topicsHeading,
                        )),
                    SizedBox(
                      height: 1.h,
                    ),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      childAspectRatio: 1.33,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        buildClickableIcon(
                          icon: Icons.restaurant_menu,
                          label: 'Canteen Meal',
                          onTap: () {
                            // final List<OrderResponse> orders =
                            //     testcontorller.generateDummyOrders();

                            // printController.uploadOrders(orders);
                            // Handle click for Menu Management
                            Get.to(() => VHomePage(),
                                transition: Transition.rightToLeft,
                                duration: duration);
                          },
                        ),
                        buildClickableIcon(
                          icon: Icons.production_quantity_limits,
                          label: 'Orders Req.',
                          onTap: () {
                            // Handle click for Order Management
                            Get.to(() => OrderRequirement(),
                                transition: Transition.rightToLeft,
                                duration: duration);
                          },
                        ),
                        buildClickableIcon(
                          icon: Icons.analytics,
                          label: 'Analytics',
                          onTap: () {
                            // Handle click for Analytics\
                            Get.to(() => AnalyticsPage(),
                                transition: Transition.rightToLeft,
                                duration: duration);
                          },
                        ),
                        buildClickableIcon(
                          icon: Icons.class_,
                          label: 'Class Analysis',
                          onTap: () {
                            // Handle click for Analytics\
                            Get.to(() => Classanalytics(),
                                transition: Transition.rightToLeft,
                                duration: duration);
                          },
                        ),
                        buildClickableIcon(
                          icon: Icons.cancel_presentation,
                          label: 'Orders Hold',
                          onTap: () {
                            // Handle click for Analytics\
                            Get.to(() => OrderCancel(),
                                transition: Transition.rightToLeft,
                                duration: duration);
                          },
                        ),
                        buildClickableIcon(
                          icon: Icons.check,
                          label: 'Order Checkout',
                          onTap: () {
                            // Handle click for Analytics\
                            Get.to(() => OrderCheckoutPage(),
                                transition: Transition.rightToLeft,
                                duration: duration);
                          },
                        )
                      ],
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the value for the desired curve
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 189, 187, 187).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0,
                          2), // Adjust the values to control the shadow appearance
                    ),
                  ],
                ),
                child: DemandSupply(),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build each clickable icon item
  Widget buildClickableIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 225, 222, 222)),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Color.fromARGB(255, 24, 20, 19),
            ),
            SizedBox(height: 8.0),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: const Color.fromARGB(255, 59, 57, 57),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
