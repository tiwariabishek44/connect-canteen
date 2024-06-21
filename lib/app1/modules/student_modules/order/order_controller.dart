import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/models/transction_api_response.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/coin%20collect/coin_collect_controller.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class StudetnORderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final coinCollectController = Get.put(CoinCollectController());
  Stream<List<OrderResponse>> fetchOrders(
      String groupCod, String schoolrefrence) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    log(schoolrefrence);
    return _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('groupcod', isEqualTo: groupCod)
        .where('checkout', isEqualTo: 'false')
        .where('orderType', isEqualTo: 'regular')
        .where('date', isEqualTo: todayDate)
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

  var coinCollectLOading = false.obs;
//----------------Collect Coin
  Future<void> collectCoin(
    double amount,
    String orderId,
    String productName,
    StudentDataResponse student,
  ) async {
    try {
      DateTime now = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final transctionDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
      final transctionTime = DateFormat('HH:mm\'', 'en').format(nepaliDateTime);

      coinCollectLOading.value = true;
      // Query for the document with the given product ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(ApiEndpoints.productionOrderCollection)
          .where('id',
              isEqualTo: orderId) // Assuming productId is the field name
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Update the 'active' field of the first document that matches the query
        await querySnapshot.docs.first.reference
            .update({'coinCollect': 'true'});
        final TransctionResponseMode transction = TransctionResponseMode(
            transctionTime: transctionTime,
            transactionType: 'collect',
            amount: amount,
            remarks: productName,
            userId: student.userid,
            userName: student.name,
            schoolReference: student.schoolId,
            className: student.classes,
            transactionDate: transctionDate);
        coinCollectController.collectCoins(transction);
      } else {
        coinCollectLOading.value = false;
        Get.snackbar('Error', 'No order found with ID: $orderId');
      }
    } catch (e) {
      coinCollectLOading.value = false;
      log(e.toString());
      Get.snackbar('Error', 'Failed to update order status: $e');
    }
  }
}
