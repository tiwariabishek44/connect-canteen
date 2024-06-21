import 'package:nepali_utils/nepali_utils.dart';

class OrderResponse {
  final String id;
  final String classs;
  final String customer;
  final String groupid;
  final String cid;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String groupcod;
  final String checkout;
  final String mealtime;
  final String date;
  final String orderType;
  final String holdDate;
  final String orderTime;
  final String customerImage;
  final String orderHoldTime;
  final String checkoutVerified;
  final String groupName;
  final String coinCollect;
  final String overFlowRead;
  final String isCahsed;
  final String scrhoolrefrenceid; // Add the scrhoolrefrenceid field

  OrderResponse({

    required this.id,
    required this.classs,
    required this.customer,
    required this.groupid,
    required this.cid,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.groupcod,
    required this.checkout,
    required this.mealtime,
    required this.date,
    required this.orderType,
    required this.holdDate,
    required this.orderTime,
    required this.customerImage,
    required this.orderHoldTime,
    required this.checkoutVerified,
    required this.groupName,
    required this.isCahsed,
    required this.coinCollect,
    required this.overFlowRead,
    required this.scrhoolrefrenceid, // Update the constructor to include scrhoolrefrenceid
  });
  NepaliDateTime get parsedDate => NepaliDateTime.parse(date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classs': classs,
      'customer': customer,
      'groupid': groupid,
      'cid': cid,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'groupcod': groupcod,
      'checkout': checkout,
      'mealtime': mealtime,
      'date': date,
      'orderType': orderType,
      'holdDate': holdDate,
      'orderTime': orderTime,
      'customerImage': customerImage,
      'orderHoldTime': orderHoldTime,
      'checkoutVerified': checkoutVerified,
      'groupName': groupName,
      'isCahsed': isCahsed,
      'coinCollect': coinCollect,
      'overFlowRead': overFlowRead,
      'scrhoolrefrenceid':
          scrhoolrefrenceid, // Add scrhoolrefrenceid to the map
    };
  }

  factory OrderResponse.fromJson(Map<String, dynamic> map) {
    return OrderResponse(
      id: map['id'],
      classs: map['classs'] ?? '',
      customer: map['customer'] ?? '',
      groupid: map['groupid'] ?? '',
      cid: map['cid'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 0,
      groupcod: map['groupcod'] ?? '',
      checkout: map['checkout'] ?? '',
      mealtime: map['mealtime'] ?? '',
      date: map['date'] ?? '',
      orderType: map['orderType'] ?? '',
      holdDate: map['holdDate'] ?? '',
      orderTime: map['orderTime'] ?? '',
      customerImage: map['customerImage'] ?? '',
      orderHoldTime: map['orderHoldTime'] ?? '',
      checkoutVerified: map['checkoutVerified'] ?? '',
      groupName: map['groupName'] ?? '',
      isCahsed: map['isCahsed'] ?? '',  
      coinCollect: map['coinCollect'] ?? '',
      overFlowRead: map['overFlowRead'] ?? '',
      scrhoolrefrenceid: map['scrhoolrefrenceid'] ??
          '', // Add scrhoolrefrenceid to fromJson factory
    );
  }
}
