// minimum_deposit_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MinimumDeposit {
  final String id;
  final double amount;
  final DateTime updatedAt;

  MinimumDeposit({
    required this.id,
    required this.amount,
    required this.updatedAt,
  });

  factory MinimumDeposit.fromJson(Map<String, dynamic> json) {
    return MinimumDeposit(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

// deposit_transaction_model.dart
class DepositTransaction {
  final String id;
  final String studentId;
  final String studentName;
  final String studentClass;
  final double amount;
  final DateTime depositDate;
  final String depositBy; // Admin ID who processed the deposit

  DepositTransaction({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    required this.amount,
    required this.depositDate,
    required this.depositBy,
  });

  factory DepositTransaction.fromJson(Map<String, dynamic> json) {
    return DepositTransaction(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      studentClass: json['studentClass'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      depositDate: (json['depositDate'] as Timestamp).toDate(),
      depositBy: json['depositBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
      'amount': amount,
      'depositDate': Timestamp.fromDate(depositDate),
      'depositBy': depositBy,
    };
  }
}
