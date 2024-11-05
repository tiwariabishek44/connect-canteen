import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class OrderRequirementController extends GetxController {
  var mealtime = "All".obs;
  var isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, Map<String, dynamic>>> getOrderRequirements(
      String schoolId) {
    final now = NepaliDateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    return _firestore
        .collection('orders')
        .where('referenceSchoolId', isEqualTo: schoolId)
        .where('mealDate', isEqualTo: today)
        .snapshots()
        .map((snapshot) => _processOrders(snapshot.docs));
  }

  Map<String, Map<String, dynamic>> _processOrders(
      List<QueryDocumentSnapshot> docs) {
    Map<String, Map<String, dynamic>> requirements = {};

    for (var doc in docs) {
      final order = OrderResponse.fromMap(doc.data() as Map<String, dynamic>);

      if (mealtime.value != "All" && order.mealTime != mealtime.value) {
        continue;
      }

      if (!requirements.containsKey(order.productName)) {
        requirements[order.productName] = {
          'quantity': 0,
          'totalPrice': 0.0,
          'unitPrice': order.price,
        };
      }

      requirements[order.productName]!['quantity'] =
          requirements[order.productName]!['quantity']! + 1;
      requirements[order.productName]!['totalPrice'] =
          requirements[order.productName]!['totalPrice']! + order.price;
    }

    return requirements;
  }

  Stream<List<OrderResponse>> getDetailedOrders(String schoolId) {
    final now = NepaliDateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    return _firestore
        .collection('orders')
        .where('referenceSchoolId', isEqualTo: schoolId)
        .where('mealDate', isEqualTo: today)
        .where('isCheckout', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                OrderResponse.fromMap(doc.data() as Map<String, dynamic>))
            .where((order) =>
                mealtime.value == "All" || order.mealTime == mealtime.value)
            .toList());
  }
}
