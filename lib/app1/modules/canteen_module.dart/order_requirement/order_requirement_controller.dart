import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class OrderRequirementController extends GetxController {
  var mealtime = "All".obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateMealtime(String newMealtime) {
    mealtime.value = newMealtime;
  }

  Stream<List<OrderResponse>> getAllTodayOrders() {
    DateTime now = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final todayDate = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

    Query query = _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('scrhoolrefrenceid', isEqualTo: "texasinternationalcollege")
        .where('date', isEqualTo: todayDate);

    if (mealtime.value != "All") {
      query = query.where('mealtime', isEqualTo: mealtime.value);
    }

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
}

class ProductDetail {
  final String productName;
  final String productImage;
  int totalQuantity;

  ProductDetail({
    required this.productName,
    required this.productImage,
    required this.totalQuantity,
  });
}
