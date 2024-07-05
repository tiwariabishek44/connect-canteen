import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:get/get.dart';

class SalesFigureController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserOrderResponse>> getAllOrder() {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    Query query = _firestore
        .collection('studentOrders')
        .where('schoolRefrenceId', isEqualTo: "texasinternationalcollege")
        .where('date', isEqualTo: todayDate);

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserOrderResponse.fromJson(
                  doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Map<String, ProductDetail> aggregateProductQuantities(
      List<UserOrderResponse> orders) {
    Map<String, ProductDetail> productQuantities = {};

    for (var order in orders) {
      for (var product in order.products) {
        if (productQuantities.containsKey(product.name)) {
          productQuantities[product.name]!.totalQuantity += product.quantity;
          productQuantities[product.name]!.totalPrice +=
              product.price * product.quantity;
        } else {
          productQuantities[product.name] = ProductDetail(
            totalQuantity: product.quantity,
            totalPrice: product.price * product.quantity,
          );
        }
      }
    }

    return productQuantities;
  }

  double calculateTotalGrossSales(
      Map<String, ProductDetail> productQuantities) {
    double totalGrossSales = 0.0;

    productQuantities.forEach((name, detail) {
      totalGrossSales += detail.totalPrice;
    });

    return totalGrossSales;
  }
}

class ProductDetail {
  int totalQuantity;
  double totalPrice;

  ProductDetail({
    required this.totalQuantity,
    required this.totalPrice,
  });
}
