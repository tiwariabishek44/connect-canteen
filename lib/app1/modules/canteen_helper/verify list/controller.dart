import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/product_detials_model.dart';
import 'package:connect_canteen/app1/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class HelperController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//------------TO GET ALL THE ORDRES OF THE GROUP

  Stream<List<OrderResponse>> getGrouppedOrder() {
    DateTime now = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final todayDate = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

    Query query = _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('scrhoolrefrenceid', isEqualTo: "texasinternationalcollege")
        .where('date', isEqualTo: todayDate)
        .where('checkoutVerified', isEqualTo: 'true')
        .where('checkout', isEqualTo: 'false')
        .where('orderType', isEqualTo: 'regular');

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  OrderResponse.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  var grouppedProduct = <String, GruoupedProductDetail>{}.obs;

  void calculateProductTotals(List<OrderResponse> orders) {
    grouppedProduct.clear(); // Clear previous totals
    for (var order in orders) {
      if (grouppedProduct.containsKey(order.productName)) {
        grouppedProduct[order.productName]!.totalQuantity += order.quantity;
      } else {
        grouppedProduct[order.groupName] = GruoupedProductDetail(
          groupName: order.groupName,
          groupCod: order.groupcod,
          totalQuantity: order.quantity,
        );
      }
    }
  }




  //--------to checkout verfy order

//------------------ TO CHECKOUT THE ORDERS
  var checkoutLoading = false.obs;
  Future<void> checkoutSelectedOrders(List<String> selectedOrderIds) async {
    checkoutLoading(true);
    WriteBatch batch = _firestore.batch();
    QuerySnapshot querySnapshot = await _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        .where('id', whereIn: selectedOrderIds)
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      batch.update(doc.reference, {'checkout': 'true'});
    }
    await batch.commit();
    checkoutLoading(false);

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return PaymentSuccessPopup(
          message: 'Successfully!',
        );
      },
    );
  }

}
