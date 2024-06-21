import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:connect_canteen/app1/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class OrderVerifyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController groupCodController = TextEditingController();
  final RxMap<String, bool> selectedOrders = <String, bool>{}.obs;
  var groupCod = ''.obs;
  var checkboxTick = false.obs;
  var selectAll = false.obs;
  List<OrderResponse> orders = [];

  var isCashed = false.obs;
//------------TO GET ALL THE ORDRES OF THE GROUP
  Stream<List<OrderResponse>> getAllGroupOrder(String groupCod) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    log("this is the date:::::::: ${todayDate}");

    return _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('groupcod',
            isEqualTo: groupCod) // Filter documents by groupid field
        .where('date', isEqualTo: todayDate)
        .where('checkout', isEqualTo: 'false')
        .where('orderType', isEqualTo: 'regular')
        .where("checkoutVerified", isEqualTo: 'false')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderResponse.fromJson(doc.data()))
              .toList(),
        );
  }

//------------------ TO CHECKOUT THE ORDERS
  var verifyLoading = false.obs;
  Future<void> verifySelectedOrders(List<String> selectedOrderIds) async {
    verifyLoading(true);
    WriteBatch batch = _firestore.batch();
    QuerySnapshot querySnapshot = await _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('id', whereIn: selectedOrderIds)
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      batch.update(doc.reference, {'checkoutVerified': 'true'});
    }
    await batch.commit();
    verifyLoading(false);

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return PaymentSuccessPopup(
          message: 'Successfully!',
        );
      },
    );
  }

  //---------- TO VALIDATE IS ORDER OR NOT
  Future<bool> validateAndFetchOrders(String groupCode) async {
    log(" this is the ${groupCod}");
    var ordersStream = getAllGroupOrder(groupCode);
    var orders = await ordersStream.first;
    return orders.isNotEmpty;
  }
}
