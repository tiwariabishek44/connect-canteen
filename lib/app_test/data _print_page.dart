import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/models/order_response.dart';

import 'package:get/get.dart';

class PrintController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var counter = 0.obs;
  Future<void> uploadOrders(List<OrderResponse> orders) async {
    try {
      counter.value = 0;
      log(" ths is the order lenth ${orders.length}");
      for (var order in orders) {
        // Add order document to Firestore with auto-generated document ID
        await Future.delayed(Duration(milliseconds: 100));
        await _firestore.collection('order').add(order.toMap());
        counter.value++;
        log("${counter.value}");
        await Future.delayed(Duration(milliseconds: 100));
      }

      // Delay between uploads
    } catch (e) {
      print('Error uploading orders: $e');
    }
  }
}
