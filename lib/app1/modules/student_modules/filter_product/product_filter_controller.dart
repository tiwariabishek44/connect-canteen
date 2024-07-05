import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:get/get.dart';

class ProductFilterController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ProductResponseModel>> getAllMenue(
      String schoolrefrence, String category) {
    return _firestore
        .collection(ApiEndpoints.productionProdcutCollection)
        .where('referenceSchool',
            isEqualTo: schoolrefrence) // Filter documents by groupid field
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductResponseModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
