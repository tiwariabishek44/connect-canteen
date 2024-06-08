import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/product_detials_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class CanteenReportController extends GetxController {

  
  var selectedDate = ''.obs;

  // to get the total order requiremnt
  Stream<List<OrderResponse>> getAllTodayOrders(String date) {
    DateTime now = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final todayDate = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Query query = _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('scrhoolrefrenceid', isEqualTo: "texasinternationalcollege")
        .where('date', isEqualTo: date);

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  OrderResponse.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  var productDetails = <String, ProductDetail>{}.obs;

  void calculateProductTotals(List<OrderResponse> orders) {
    productDetails.clear(); // Clear previous totals
    for (var order in orders) {
      if (productDetails.containsKey(order.productName)) {
        productDetails[order.productName]!.totalQuantity += order.quantity;
      } else {
        productDetails[order.productName] = ProductDetail(
          productName: order.productName,
          productImage: order.productImage,
          totalQuantity: order.quantity,
        );
      }
    }
  }

  // to get the total uncheckout orer
  Stream<List<OrderResponse>> getallUncheckoutOrder(String date) {
    DateTime now = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final todayDate = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    log(" this is today date :::::: ${todayDate}");

    return firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('scrhoolrefrenceid', isEqualTo: "texasinternationalcollege")
        .where('date', isEqualTo: date)
        .where('checkout', isEqualTo: 'false')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderResponse.fromJson(doc.data()))
              .toList(),
        );
  }

  var uncheckoutOrderDetails = <String, ProductDetail>{}.obs;

  void calculateUncheckoutOrder(List<OrderResponse> orders) {
    log(" we are doing fantasti ");
    uncheckoutOrderDetails.clear(); // Clear previous totals
    for (var order in orders) {
      if (uncheckoutOrderDetails.containsKey(order.productName)) {
        uncheckoutOrderDetails[order.productName]!.totalQuantity +=
            order.quantity;
      } else {
        uncheckoutOrderDetails[order.productName] = ProductDetail(
          productName: order.productName,
          productImage: order.productImage,
          totalQuantity: order.quantity,
        );
      }
    }
  }
}
