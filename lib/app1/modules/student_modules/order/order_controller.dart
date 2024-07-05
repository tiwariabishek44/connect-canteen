import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/models/transction_api_response.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/model/transction_model.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class StudetnORderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<UserOrderResponse>> fetchOrders(
      String cid, String schoolrefrence) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";
    return _firestore
        .collection("studentOrders")
        .where('userId', isEqualTo: cid)
        .where('status', isEqualTo: 'uncompleted')
        // .where('scrhoolrefrenceid',
        //     isEqualTo: schoolrefrence) // Filter documents by groupid field
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => UserOrderResponse.fromJson(doc.data()))
            .toList();
      },
    );
  }

  Stream<List<UserOrderResponse>> fetchHistory(
      String cid, String schoolrefrence) {
    log(schoolrefrence);
    return _firestore
        .collection("studentOrders")
        .where('userId', isEqualTo: cid)
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserOrderResponse.fromJson(doc.data()))
              .toList(),
        );
  }

  //------------TO FETCH THE HOLD ORDER OR USER

  Stream<List<OrderResponse>> fetchHoldOrders(
      String cid, String schoolrefrence) {
    log(schoolrefrence);
    return _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('cid', isEqualTo: cid)
        .where('checkout', isEqualTo: 'false')
        .where('orderType', isEqualTo: 'hold')
        .where('scrhoolrefrenceid',
            isEqualTo: schoolrefrence) // Filter documents by groupid field
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderResponse.fromJson(doc.data()))
              .toList(),
        );
  }
}
