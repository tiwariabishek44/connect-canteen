import 'dart:developer';

import 'package:connect_canteen/app/widget/payment_succesfull.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/payment_succestullPage.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:connect_canteen/app1/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class TransctionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var totalbalances = 0.0.obs;
  final GlobalKey<FormState> balanceFormKey = GlobalKey<FormState>();
  var add = false.obs;
  var showmore = false.obs;
  var totalLoad = 0.obs;

  // Method to add transaction
  var transctionUploading = false.obs;
  Future<void> uploadTransaction(TransctionResponseMode transaction) async {
    try {
      log('Uploading transaction: ${transaction.amount}');
      transctionUploading.value = true;
      await _firestore
          .collection(ApiEndpoints.productionTransctionCollection)
          .add(transaction.toJson());
      transctionUploading.value = false;
      Get.off(() => SuccesfullPayment(
            amountPaid: transaction.amount.toInt(),
          ));
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload transaction: $e');
    }
  }

//
  Future<void> uploadTransactions(TransctionResponseMode transaction) async {
    try {
      log('Uploading transaction: ${transaction.amount}');
      transctionUploading.value = true;
      await _firestore
          .collection(ApiEndpoints.productionTransctionCollection)
          .add(transaction.toJson());
      transctionUploading.value = false;
      Get.to(() => SuccesfullPayment(
            amountPaid: transaction.amount.toInt(),
          ));
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload transaction: $e');
    }
  }

//---------------------------------to fetch the transction

  Stream<List<TransctionResponseMode>> fetchAllTransction(
      String userid, String schoolrefrence) {
    log('thi is he transctin ');
    return _firestore
        .collection(ApiEndpoints.productionTransctionCollection)
        .where('userId', isEqualTo: userid)
        .where('schoolReference',
            isEqualTo: schoolrefrence) // Filter documents by groupid field
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransctionResponseMode.fromJson(doc.data()))
              .toList(),
        );
  }

  // Method to calculate total load, total penalty, and total balance
  Map<String, double> calculateTotals(
      List<TransctionResponseMode> transactions) {
    double totalLoad = 0.0;
    double totalPenalty = 0.0;

    for (TransctionResponseMode transaction in transactions) {
      if (transaction.transactionType.toUpperCase() == 'LOAD') {
        totalLoad += transaction.amount;
      } else if (
          // transaction.transactionType.toUpperCase() == 'PURCHASE' ||
          transaction.transactionType.toUpperCase() == 'PENALTY') {
        totalPenalty += transaction.amount;
      }
    }

    double totalBalance = totalLoad - totalPenalty;
    totalbalances.value = totalBalance;
    log('message $totalBalance');

    return {
      'totalLoad': totalLoad,
      'totalPenalty': totalPenalty,
      'totalBalance': totalBalance,
    };
  }

  // Method to calculate friend's balance
  Future<int> friendBalance(String userid, String schoolid) async {
    double totalLoad = 0.0;
    double totalPenalty = 0.0;

    QuerySnapshot snapshot = await _firestore
        .collection(ApiEndpoints.productionTransctionCollection)
        .where('userId', isEqualTo: userid)
        .where('schoolReference', isEqualTo: schoolid)
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      TransctionResponseMode transaction =
          TransctionResponseMode.fromJson(doc.data() as Map<String, dynamic>);
      if (transaction.transactionType.toUpperCase() == 'LOAD') {
        totalLoad += transaction.amount;
      } else if (transaction.transactionType.toUpperCase() == 'PENALTY') {
        totalPenalty += transaction.amount;
      }
    }

    double totalBalance = totalLoad - totalPenalty;
    return totalBalance.toInt();
  }

  String selectedFilter = ''; // Property to track selected filter
}
