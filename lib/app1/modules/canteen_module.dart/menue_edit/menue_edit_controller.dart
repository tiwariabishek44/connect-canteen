import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenueEditController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> priceFormKey = GlobalKey<FormState>();

  final TextEditingController priceController = TextEditingController();
  final updateLOading = false.obs;

  void doPriceUpdate(String productId, double broductPrice) {
    if (priceFormKey.currentState!.validate()) {
      updatePriductPrice(productId, broductPrice);
    } else {
      CustomSnackbar.error(Get.context!, 'Enter the new price');
    }
  }

  //----------- TO FETCH THE MEAL PRODUCT
  Stream<ProductResponseModel?> getmenueProduct(
      String proudctId, String refrenceSchool) {
    return _firestore
        .collection(ApiEndpoints.productionProdcutCollection)
        .where('productId', isEqualTo: proudctId)
        .where('referenceSchool', isEqualTo: refrenceSchool)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Assuming that userId is unique and there will be only one document
        return ProductResponseModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

//--------------- UPDATE THE PRODUCT STATE
  Future<void> updateProductActiveStatus(
      String productId, bool isActive) async {
    try {
      // Query for the document with the given product ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(ApiEndpoints.productionProdcutCollection)
          .where('productId',
              isEqualTo: productId) // Assuming productId is the field name
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Update the 'active' field of the first document that matches the query
        await querySnapshot.docs.first.reference.update({'active': isActive});
        CustomSnackbar.success(Get.context!, 'updated successfully');
      } else {
        Get.snackbar('Error', 'No product found with ID: $productId');
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Failed to update product status: $e');
    }
  }

  //----------------UPDATE THE PRICE
  Future<void> updatePriductPrice(String productId, double productPrice) async {
    try {
      updateLOading.value = true;
      // Query for the document with the given product ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(ApiEndpoints.productionProdcutCollection)
          .where('productId',
              isEqualTo: productId) // Assuming productId is the field name
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Update the 'active' field of the first document that matches the query
        await querySnapshot.docs.first.reference
            .update({'price': double.parse(priceController.text.trim())});
        updateLOading(false);
        CustomSnackbar.success(Get.context!, 'updated successfully');
        priceController.clear();
      } else {
        updateLOading(false);
        CustomSnackbar.error(Get.context!, 'Error while updating');
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Failed to update product status: $e');
    }
  }
}
