import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/admin_summary.dart';
import 'package:connect_canteen/app1/model/transction_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class StatementController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var selectedDate = ''.obs;
  var grandTotal = 0.0.obs;

  // Stream to fetch AdminSummary documents
  Stream<List<TransactionResponseModel>> getStatement(
      String schoolReference, String filterOption) {
    log(selectedDate.value);
    Stream<List<TransactionResponseModel>> stream;
    if (selectedDate.value == '') {
      selectedDate.value = todayDate;
      log('Selected date: $selectedDate');

      stream = _firestore
          .collection('Transactions')
          .where('schoolReference', isEqualTo: schoolReference)
          .where('date', isEqualTo: todayDate)
          .where('type', isEqualTo: "load")
          .snapshots()
          .map(adminSummaryFromSnapshot);
    } else {
      stream = _firestore
          .collection('Transactions')
          .where('schoolReference', isEqualTo: schoolReference)
          .where('date', isEqualTo: filterOption)
          .where('type', isEqualTo: "load")
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
  List<TransactionResponseModel> adminSummaryFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TransactionResponseModel.fromMap(
          doc.data() as Map<String, dynamic>);
    }).toList();
  }
}

DateTime now = DateTime.now();

NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
final todayDate = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
