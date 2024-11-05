import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DepositHistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;

  // Stream deposit history for specific student
  Stream<List<DepositTransaction>> getStudentDepositHistory(String studentId) {
    return _firestore
        .collection('deposits')
        .where('studentId', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DepositTransaction.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  // Stream all deposits for school
  Stream<List<DepositTransaction>> getSchoolDepositHistory(String schoolId) {
    return _firestore
        .collection('deposits')
        .where('schoolId', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DepositTransaction.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  // Get formatted date
  String getFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }
}

// Deposit Transaction Model
class DepositTransaction {
  final String id;
  final String studentId;
  final String studentName;
  final String className;
  final double amount;
  final DateTime date;
  final String schoolId;

  DepositTransaction({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.className,
    required this.amount,
    required this.date,
    required this.schoolId,
  });

  factory DepositTransaction.fromJson(Map<String, dynamic> json) {
    return DepositTransaction(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      className: json['className'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: (json['date'] as Timestamp).toDate(),
      schoolId: json['schoolId'] ?? '',
    );
  }
}
