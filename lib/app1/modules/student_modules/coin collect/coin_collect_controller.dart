import 'dart:developer';

import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/payment_succestullPage.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoinCollectController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var totalbalances = 0.0.obs;
  var showmore = false.obs;
  var totalLoad = 0.obs;

  // Method to add transaction
  Future<void> collectCoins(TransctionResponseMode transaction) async {
    try {
      await _firestore
          .collection(ApiEndpoints.productionCoinCollection)
          .add(transaction.toJson());
      CustomSnackbar.success(Get.context!, 'Coin Collect successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload transaction: $e');
    }
  }

//---------------------------------to fetch the coin

  Stream<List<TransctionResponseMode>> fetchCoinsLog(
      String userid, String schoolrefrence) {
    return _firestore
        .collection(ApiEndpoints.productionCoinCollection)
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
    log('calculating totals ${transactions[0].transactionType}');

    double totalCoin = 0.0;
    double totalUse = 0.0;

    for (TransctionResponseMode transaction in transactions) {
      if (transaction.transactionType.toLowerCase() == 'collect') {
        log(" transaction.amount ${transaction.amount}  ");
        totalCoin += transaction.amount;
      } else if (transaction.transactionType.toLowerCase() == 'use') {
        log('transaction.transactionType ${transaction.amount}');
        totalUse += transaction.amount;
      }
    }

    double totalBalance = totalCoin - totalUse;
    totalbalances.value = totalBalance;

    return {
      'totalcollect': totalCoin,
      'totalPenalty': totalUse,
      'totalBalance': totalBalance,
    };
  }

  String selectedFilter = ''; // Property to track selected filter
}
