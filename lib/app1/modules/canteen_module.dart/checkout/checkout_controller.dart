import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CheckoutController extends GetxController {
  var loading = false.obs;
  Future<void> orderCheckout(
    String otpcode,
    String username,
    String classname,
    String mealtime,
  ) async {
    try {
      loading(true);
      // Query for the document with the given product ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("studentOrders")
          .where('username', isEqualTo: username)
          .where('mealTime', isEqualTo: mealtime)
          .where('userClass', isEqualTo: classname)
          .where('status', isEqualTo: 'uncompleted')
          .where("otp",
              isEqualTo: otpcode) // Assuming productId is the field name
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'status': 'completed',
          'otp': '',
        });
        Get.off(() => OrderCheckoutSuccessPage(
              orderNumber: '',
              orderDate: '',
              totalAmount: 100,
              deliveryTime: '',
              deliveryAddress: '',
            ));
        loading(false);
      } else {
        log('No such document found!');
        loading(false);
      }
    } catch (e) {
      log("Error: $e");
      loading(false);
    }
  }
}

class OrderCheckoutSuccessPage extends StatelessWidget {
  final String orderNumber;
  final String orderDate;
  final double totalAmount;
  final String deliveryTime;
  final String deliveryAddress;

  OrderCheckoutSuccessPage({
    required this.orderNumber,
    required this.orderDate,
    required this.totalAmount,
    required this.deliveryTime,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            Text('Order Confirmation', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50.sp),
                SizedBox(height: 16),
                Text(
                  'Thank You!',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Order Checkout Succesfully.',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 16),
                //make the curve edge button ( Go Back)
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 175, 152, 76),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
