import 'dart:developer';

import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var totalbalances = 0.0.obs;
  // Method to create a wallet for a user
  Future<void> createWallet(String userId, String userName) async {
    try {
      await _firestore
          .collection(ApiEndpoints.prodcutionWalletCollection)
          .doc(userId)
          .set({
        'userId': userId,
        'userName': userName,
        'transactions': [],
      });
      // Show success popup
    } catch (e) {
      print("Error creating wallet: $e");
      // Show error popup
    }
  }

  final transctionAdd = false.obs;
  // Method to add a transaction to a wallet
  Future<void> addTransaction(String userId, Transactions transaction) async {
    try {
      transctionAdd(true);
      await _firestore
          .collection(ApiEndpoints.prodcutionWalletCollection)
          .doc(userId)
          .update({
        'transactions': FieldValue.arrayUnion([transaction.toJson()]),
      });
      transctionAdd(false);
    } catch (e) {
      transctionAdd(false);
    }
  }

  // Method to fetch wallet data for a user
  Stream<Wallet?> getWallet(String userId) {
   
    return _firestore
        .collection(ApiEndpoints.prodcutionWalletCollection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return Wallet.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  // Method to calculate total load, total penalty, and total balance
  Map<String, double> calculateTotals(List<Transactions> transactions) {
    double totalLoad = 0.0;
    double totalPenalty = 0.0;

    for (Transactions transaction in transactions) {
      if (transaction.name == 'load') {
        totalLoad += transaction.amount;
      } else if (transaction.name == 'Purchase') {
        totalPenalty += transaction.amount;
      }
    }

    double totalBalance = totalLoad - totalPenalty;
    totalbalances.value = totalBalance;

    return {
      'totalLoad': totalLoad,
      'totalPenalty': totalPenalty,
      'totalBalance': totalBalance,
    };
  }

  String selectedFilter = ''; // Property to track selected filter

  void filterTransactions(String filter) {
    selectedFilter = filter;
    update(); // Update UI to reflect changes
  }
}
