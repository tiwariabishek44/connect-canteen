class TransactionResponseModel {
  String userId;
  String type;
  double amount;
  String date;
  String status;
  String itemId;
  String schoolReference;
  String classes;
  String studentName;

  TransactionResponseModel({
    required this.classes,
    required this.studentName,
    required this.schoolReference,
    required this.userId,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    required this.itemId,
  });

  // Convert a TransactionModel into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'classes': classes,
      'studentName': studentName,
      'schoolReference': schoolReference,
      'userId': userId,
      'type': type,
      'amount': amount,
      'date': date,
      'status': status,
      'itemId': itemId,
    };
  }

  // Create a TransactionModel from a Map.
  factory TransactionResponseModel.fromMap(Map<String, dynamic> map) {
    return TransactionResponseModel(
      classes: map['classes'],
      studentName: map['studentName'],
      schoolReference: map['schoolReference'],
      userId: map['userId'],
      type: map['type'],
      amount: map['amount'],
      date: map['date'],
      status: map['status'],
      itemId: map['itemId'],
    );
  }
}
