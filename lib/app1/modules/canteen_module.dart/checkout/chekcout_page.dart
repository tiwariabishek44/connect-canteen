import 'dart:async';
import 'dart:developer';

import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/checkout_controller.dart';

class OrderCheckoutPage extends StatefulWidget {
  final UserOrderResponse order;

  OrderCheckoutPage({required this.order});

  @override
  _OrderCheckoutPageState createState() => _OrderCheckoutPageState();
}

class _OrderCheckoutPageState extends State<OrderCheckoutPage> {
  final checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            title:
                Text('Orders Checkout', style: TextStyle(color: Colors.black)),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildOrderDetails(),
                SizedBox(height: 20),
                Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child: _buildProductList()),
              ],
            ),
          ),
          floatingActionButton: Container(
            width: 200, // Set the desired width here
            child: FloatingActionButton.extended(
              onPressed: _handleCheckout,
              backgroundColor: Colors.black,
              label: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 19.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Positioned(
            child: Obx(() => checkoutController.loading.value
                ? LoadingWidget()
                : SizedBox.shrink()))
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Name:', widget.order.username),
          _buildDetailRow('Class:', widget.order.userClass),
          _buildDetailRow('Status:', widget.order.status),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: widget.order.products.length,
      itemBuilder: (context, index) {
        final product = widget.order.products[index];
        return Column(
          children: [
            ListTile(
              title: Text(product.name),
              subtitle: Text('Quantity: ${product.quantity}'),
            ),
            Divider(),
          ],
        );
      },
    );
  }

  void _handleCheckout() async {
    await checkoutController.orderCheckout(widget.order.otp,
        widget.order.username, widget.order.userClass, widget.order.mealTime);
  }
}
