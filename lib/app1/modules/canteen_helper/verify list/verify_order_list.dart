import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/product_detials_model.dart';
import 'package:connect_canteen/app1/modules/canteen_helper/verify%20list/controller.dart';
import 'package:connect_canteen/app1/modules/canteen_helper/verify_checkout/verify_checkout.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/chekcout_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/utils/order_tile_shrimmer.dart';
import 'package:connect_canteen/app1/widget/no_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerifyOrderList extends StatelessWidget {
  VerifyOrderList({super.key});
  final controller = Get.put(HelperController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0.w, // Adjusts the spacing above the title
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Verify Order List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<OrderResponse>>(
        stream: controller.getGrouppedOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  CanteenOrderTilesShrimmer();
                });
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoOrder(
              onClick: () {},
            );
          }

          var orders = snapshot.data!;
          controller.calculateProductTotals(orders);

          return Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.grouppedProduct.length,
                  itemBuilder: (context, index) {
                    String productName =
                        controller.grouppedProduct.keys.toList()[index];
                    GruoupedProductDetail detail =
                        controller.grouppedProduct[productName]!;

                    return GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            VerifyOrderCheckoutPage(
                            groupCode: detail.groupCod));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius: BorderRadius.circular(
                              10), // Border radius if needed
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 230, 227, 227)
                                  .withOpacity(0.5), // Shadow color
                              spreadRadius: 5, // Spread radius
                              blurRadius: 7, // Blur radius
                              offset: Offset(0, 3), // Offset
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Group :${detail.groupName}", // Show the groupName
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 21.sp),
                              ),
                              Text(
                                '',
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
