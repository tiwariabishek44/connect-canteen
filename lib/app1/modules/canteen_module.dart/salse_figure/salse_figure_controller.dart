import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class SalseFigureController extends GetxController {
  var grandTotal = 0.0.obs; // Observable grand total
  var netTotal = 0.0.obs; // Observable net total

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all orders of the group
  Stream<List<OrderResponse>> getAllOrder(String date) {
    DateTime now = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final todayDate = DateFormat('dd/MM/yyyy', 'en').format(nepaliDateTime);

    return _firestore
        .collection(ApiEndpoints.productionOrderCollection)
        // Filter documents by date field
        .where('date', isEqualTo: date)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderResponse.fromJson(doc.data()))
              .toList(),
        );
  }

  // Method to calculate both grand total and net total
  void calculateTotals(List<OrderResponse> orders) {
    grandTotal.value = 0.0; // Reset grand total
    netTotal.value = 0.0; // Reset net total

    for (var order in orders) {
      grandTotal.value += order.price; // Calculate grand total
      if (order.checkout == "true") {
        netTotal.value +=
            order.price; // Calculate net total if checkout is true
      }
    }
  }
}
