import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/order_response.dart';

import 'package:get/get.dart';

class CanteenReportController extends GetxController {
  var selectedDate = ''.obs;

  Stream<List<UserOrderResponse>> getAllTodayOrders(String date) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query query = firestore
        .collection('studentOrders')
        .where('schoolRefrenceId', isEqualTo: "texasinternationalcollege")
        .where('date', isEqualTo: date);

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserOrderResponse.fromJson(
                  doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Stream<List<UserOrderResponse>> getRemaningOrder(String date) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query query = firestore
        .collection('studentOrders')
        .where('schoolRefrenceId', isEqualTo: "texasinternationalcollege")
        .where('status', isEqualTo: 'uncompleted')
        .where('date', isEqualTo: date);

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserOrderResponse.fromJson(
                  doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}

Map<String, int> aggregateProductQuantities(List<UserOrderResponse> orders) {
  Map<String, int> productQuantities = {};

  for (var order in orders) {
    for (var product in order.products) {
      if (productQuantities.containsKey(product.name)) {
        productQuantities[product.name] =
            productQuantities[product.name]! + product.quantity;
      } else {
        productQuantities[product.name] = product.quantity;
      }
    }
  }

  return productQuantities;
}
