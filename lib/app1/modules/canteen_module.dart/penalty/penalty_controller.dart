import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class PenaltyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final transctionController = Get.put(TransctionController());

  var isCashed = true.obs;
//------------TO GET ALL THE ORDRES OF THE GROUP
  Stream<List<OrderResponse>> getAllOrder() {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    return _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('scrhoolrefrenceid',
            isEqualTo:
                "texasinternationalcollege") // Filter documents by groupid field
        .where('checkout', isEqualTo: 'false')
        .where('orderType', isEqualTo: 'regular')
        .where('date', isEqualTo: todayDate)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderResponse.fromJson(doc.data()))
              .toList(),
        );
  }

  var penaltyChargeLoading = false.obs;

  Future<void> verifySelectedOrder(OrderResponse order) async {
    DateTime now = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final penaltyTime = DateFormat('HH:mm\'', 'en').format(nepaliDateTime);

    try {
      penaltyChargeLoading(true);

      QuerySnapshot querySnapshot = await _firestore
          .collection(ApiEndpoints.productionOrderCollection)
          .where('id', isEqualTo: order.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot orderDoc = querySnapshot.docs.first;
        await orderDoc.reference
            .update({'orderType': 'penalty', 'checkout': 'true'});

        // Create and upload transaction
        TransctionResponseMode transaction = TransctionResponseMode(
          userId: order.cid,
          userName: order.customer,
          schoolReference: 'texasinternationalcollege',
          className: order.classs,
          remarks: '${order.productName}/ Qnty-${order.quantity}',
          transactionType: 'penalty',
          amount: order.price,
          transactionDate: order.date,
          transctionTime: penaltyTime,
        );
        await transctionController.uploadTransactions(transaction);
        penaltyChargeLoading(false);
      } else {}
    } catch (error) {
      log('Error verifying order: $error');
    } finally {
      penaltyChargeLoading(false);
    }
  }
}
