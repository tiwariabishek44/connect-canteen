import 'package:cloud_firestore/cloud_firestore.dart';

class OrderResponse {
  final String orderId;
  final String studentId;
  final String referenceSchoolId;
  final String mealType;
  final String mealTime;
  final double price;
  final bool isCheckout;
  final DateTime orderDate; // When the order was placed
  final String mealDate; // When the meal is to be served
  final Timestamp createdAt;
  final String productName;
  final String studentName;
  final String itemType;
  final String phoneno;

  OrderResponse({
    required this.orderId,
    required this.studentId,
    required this.referenceSchoolId,
    required this.mealType,
    required this.mealTime,
    required this.price,
    required this.isCheckout,
    required this.orderDate,
    required this.mealDate,
    required this.createdAt,
    required this.productName,
    required this.studentName,
    required this.itemType,
    required this.phoneno,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'studentId': studentId,
      'referenceSchoolId': referenceSchoolId,
      'mealType': mealType,
      'mealTime': mealTime,
      'price': price,
      'isCheckout': isCheckout,
      'orderDate': Timestamp.fromDate(orderDate),
      'mealDate': mealDate,
      'createdAt': createdAt,
      'productName': productName,
      'studentName': studentName,
      'itemType': itemType,
      'phoneno': phoneno,
    };
  }

  factory OrderResponse.fromMap(Map<String, dynamic> map) {
    return OrderResponse(
      orderId: map['orderId'] ?? '',
      studentId: map['studentId'] ?? '',
      referenceSchoolId: map['referenceSchoolId'] ?? '',
      mealType: map['mealType'] ?? '',
      mealTime: map['mealTime'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      isCheckout: map['isCheckout'] ?? false,
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      mealDate: map['mealDate'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      productName: map['productName'] ?? '',
      studentName: map['studentName'] ?? '',
      itemType: map['itemType'] ?? '',
      phoneno: map['phoneno'] ?? '',
    );
  }
}
