class Transactions {
  final DateTime date;
  final String name;
  final double amount;
  final String remarks;

  Transactions({
    required this.date,
    required this.name,
    required this.amount,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'name': name,
      'amount': amount,
      'purchaseItem': remarks,
    };
  }

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      date: DateTime.parse(json['date']),
      name: json['name'],
      amount: json['amount'],
      remarks: json['purchaseItem'],
    );
  }
}

class Wallet {
  final String userId;
  final String userName;
  final List<Transactions> transactions;

  Wallet({
    required this.userId,
    required this.userName,
    required this.transactions,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'transactions':
          transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      userId: json['userId'],
      userName: json['userName'],
      transactions: (json['transactions'] as List<dynamic>)
          .map((transactionJson) => Transactions.fromJson(transactionJson))
          .toList(),
    );
  }
}
