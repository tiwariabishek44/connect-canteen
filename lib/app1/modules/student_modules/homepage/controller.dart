import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:get/get.dart';

class MenueContorller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void searchItems(String query) {
    searchQuery.value = query;
  }

  Stream<List<ProductResponseModel>> getAllMenue(String schoolrefrence) {
    return _firestore
        .collection(ApiEndpoints.productionProdcutCollection)
        .where('referenceSchool',
            isEqualTo: schoolrefrence) // Filter documents by groupid field
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductResponseModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
