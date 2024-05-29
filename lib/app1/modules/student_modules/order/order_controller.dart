import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:get/get.dart';

class StudetnORderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<OrderResponse>> fetchOrders(
      String groupCod, String schoolrefrence) {
    log(schoolrefrence);
    return _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('groupcod', isEqualTo: groupCod)
        .where('checkout', isEqualTo: 'false')
        .where('orderType', isEqualTo: 'regular')
        .where('scrhoolrefrenceid',
            isEqualTo: schoolrefrence) // Filter documents by groupid field
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderResponse.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<OrderResponse>> fetchHistory(
      String groupCod, String schoolrefrence) {
    log(schoolrefrence);
    return _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('groupcod', isEqualTo: groupCod)
        .where('checkout', isEqualTo: 'true')
        .where('orderType', isEqualTo: 'regular')
        .where('scrhoolrefrenceid',
            isEqualTo: schoolrefrence) // Filter documents by groupid field
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderResponse.fromJson(doc.data()))
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
