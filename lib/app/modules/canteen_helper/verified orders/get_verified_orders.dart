import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/canteen_helper/verified%20orders/get_group_order.dart';
import 'package:connect_canteen/app/modules/canteen_helper/verified%20orders/verify_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/orders_checkout/veodor_order_controller.dart';
import 'package:connect_canteen/app/repository/order_requirement_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CanteenHelper extends StatelessWidget {
  final verifyController = Get.put(VerifyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        iconrequired: true,
        title: 'Verify Order',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<Map<String, List<OrderResponse>>>(
          stream: verifyController.groupOrdersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found.'));
            }

            final ordersByProduct = snapshot.data!;
            return ListView.builder(
              itemCount: ordersByProduct.length,
              itemBuilder: (context, index) {
                final groupCode = ordersByProduct.keys.toList()[index];
                final List<OrderResponse> orders = ordersByProduct[groupCode]!;
                final totalQuantity = orders
                    .map((order) => order.quantity)
                    .reduce((value, element) => value + element);

                // Extracting the groupName from any order, assuming it's the same for all orders in the group
                final groupName =
                    orders.isNotEmpty ? orders.first.groupName : '';

                return GestureDetector(
                  onTap: () {
                    verifyController.groupCod.value = groupCode;
                    verifyController.fetchOrders();
                    Get.to(() => GetGrouOrder(),
                        transition: Transition.rightToLeft, duration: duration);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(10), // Border radius if needed
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
                            "Group Name: $groupName", // Show the groupName
                            style: AppStyles.topicsHeading1,
                          ),
                          Text(
                            'Total Quantity: $totalQuantity-Plate',
                            style: AppStyles.topicsHeading,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
