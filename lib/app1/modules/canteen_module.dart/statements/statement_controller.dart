import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/admin_summary.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class StatementController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var selectedDate = ''.obs;
  var grandTotal = 0.0.obs;

  // Stream to fetch AdminSummary documents
  Stream<List<TransctionResponseMode>> getStatement(
      String schoolReference, String filterOption) {
    log(selectedDate.value);
    Stream<List<TransctionResponseMode>> stream;
    if (selectedDate.value == '') {
      selectedDate.value = todayDate;
      stream = _firestore
          .collection(ApiEndpoints.productionTransctionCollection)
          .where('schoolReference', isEqualTo: schoolReference)
          .where('transactionDate', isEqualTo: todayDate)
          .snapshots()
          .map(adminSummaryFromSnapshot);
    } else {
      stream = _firestore
          .collection(ApiEndpoints.productionTransctionCollection)
          .where('schoolReference', isEqualTo: schoolReference)
          .where('transactionDate', isEqualTo: filterOption)
          .snapshots()
          .map(adminSummaryFromSnapshot);
    }

    stream.listen((adminSummaries) {
      double total = 0.0;
      for (var summary in adminSummaries) {
        total += summary.amount;
      }
      grandTotal.value = total;
    });

    return stream;
  }

  // Function to convert Firestore snapshot to a list of AdminSummary objects
  List<TransctionResponseMode> adminSummaryFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TransctionResponseMode.fromJson(
          doc.data() as Map<String, dynamic>);
    }).toList();
  }
}

DateTime now = DateTime.now();

NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
final todayDate = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
