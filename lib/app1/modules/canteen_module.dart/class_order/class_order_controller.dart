import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:get/get.dart';

class ClassOrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserOrderResponse>> fetchOrders(
      String grade, String schoolrefrence) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";
    return _firestore
        .collection("studentOrders")
        .where('userClass', isEqualTo: grade)
        .where('date', isEqualTo: todayDate)
        .where('status', isEqualTo: 'uncompleted')
        // .where('scrhoolrefrenceid',
        //     isEqualTo: schoolrefrence) // Filter documents by groupid field
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => UserOrderResponse.fromJson(doc.data()))
            .toList();
      },
    );
  }
}
