import 'dart:developer';

import 'package:connect_canteen/app/widget/payment_succesfull.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/model/transction_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/payment_succestullPage.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:connect_canteen/app1/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransctionController extends GetxController {
  var showMoney = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var totalbalances = 0.0.obs;
  final GlobalKey<FormState> balanceFormKey = GlobalKey<FormState>();
  var add = false.obs;
  var showmore = false.obs;
  var totalLoad = 0.obs;

  // Method to add transaction
  var transctionUploading = false.obs;

  //----------------------to fetch wallet amount of user
  final studentDataResponse = Rxn<StudentDataResponse?>();

  Stream<StudentDataResponse?> getStudetnData({String? userIds}) {
    return _firestore
        .collection(ApiEndpoints.prodcutionStudentCollection)
        .where('userid', isEqualTo: userIds)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        studentDataResponse.value = StudentDataResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);

        // Assuming that userId is unique and there will be only one document
        return StudentDataResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

//---------------------------------to fetch the transction
  Stream<List<TransactionResponseModel>> fetchAllTransction(
    String userid,
  ) {
    try {
      log(('Fetching transactions for user: $userid'));
      return _firestore
          .collection('Transactions')
          .where('userId', isEqualTo: userid)
          .snapshots()
          .map((snapshot) {
        log('Transaction fetched: ${snapshot.docs.length}');
        return snapshot.docs
            .map((doc) => TransactionResponseModel.fromMap(doc.data()))
            .toList();
      });
    } catch (error) {
      log('Error fetching transactions: $error');
      return Stream.error(error);
    }
  }

  var orderLoading = false.obs;
  Future<void> loadWallet(
    double amount,
    String userid,
    String studentName,
    String classes,
  ) async {
    try {
      DateTime nowUtc = DateTime.now().toUtc();
      DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
      final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

      orderLoading.value = true;
      DocumentReference userDoc =
          _firestore.collection('productionStudents').doc(userid);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        double currentBalance = snapshot['balance'];

        double newBalance = currentBalance + amount;

        transaction.update(userDoc, {'balance': newBalance});

        transaction.set(_firestore.collection('Transactions').doc(), {
          'userId': userid,
          'type': 'load',
          'amount': amount,
          'date': todayDate,
          'status': 'completed',
          'classes': classes,
          'studentName': studentName,
          'schoolReference': "texasinternationalcollege",
          'itemId': '',
        });
        Get.to(() => SuccesfullPayment(
              amountPaid: amount.toInt(),
            ));
      });

      orderLoading.value = false;
    } catch (error) {
      log('Error making order: $error');
      orderLoading.value = false;
      if (error.toString() == "Insufficient funds!") {
        showInsufficientBalanceDialog(Get.context!,
            message: 'You have insufficient balance to make this order',
            title: 'Insufficient Balance');
      } else {
        showInsufficientBalanceDialog(Get.context!);
      }
    }
  }
}

void showInsufficientBalanceDialog(BuildContext context,
    {String? message, String? title}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
