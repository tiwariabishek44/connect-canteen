import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenueContorller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedCategory = 'Basic Items'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

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

  Future<bool> deleteProduct(String productId) async {
    try {
      isLoading.value = true;

      await _firestore
          .collection(ApiEndpoints.productionProdcutCollection)
          .doc(productId)
          .delete();

      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
