class TransctionResponseMode {
  final String transactionType;
  final double amount;
  final String remarks;
  final String userId;
  final String userName;
  final String schoolReference;
  final String className;
  final String transactionDate;
  final String transctionTime;

  TransctionResponseMode({
    required this.transctionTime,
    required this.transactionType,
    required this.amount,
    required this.remarks,
    required this.userId,
    required this.userName,
    required this.schoolReference,
    required this.className,
    required this.transactionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'amount': amount,
      'remarks': remarks,
      'userId': userId,
      'userName': userName,
      'schoolReference': schoolReference,
      'className': className,
      'transactionDate': transactionDate,
      'transctionTime': transctionTime,
    };
  }

  factory TransctionResponseMode.fromJson(Map<String, dynamic> json) {
    return TransctionResponseMode(
      transactionType: json['transactionType'],
      amount: json['amount'],
      remarks: json['remarks'],
      userId: json['userId'],
      userName: json['userName'],
      schoolReference: json['schoolReference'],
      className: json['className'],
      transactionDate: json['transactionDate'],
      transctionTime: json['transctionTime'],
    );
  }
}
