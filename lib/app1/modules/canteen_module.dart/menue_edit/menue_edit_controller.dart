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

        CustomSnackbar.success(Get.context!, 'updated successfully');
        priceController.clear();
      } else {
        Get.snackbar('Error', 'No product found with ID: $productId');
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Failed to update product status: $e');
    }
  }

//-------------UPLOAD THE PROUDCT
  final uploadloading = false.obs;
  Future<void> uploadProducts() async {
    try {
      final List<ProductResponseModel> products = [
        // Provide your list of products here
        ProductResponseModel(
          type: "VEG",
          proudctImage:
              'https://tb-static.uber.com/prod/image-proc/processed_images/738d85f881e2063a399fa8858183c06e/b4facf495c22df52f3ca635379ebe613.jpeg',
          name: 'Product 1',
          price: 19.99,
          productId: 'texasinternationalcollege1',
          referenceSchool: 'texasinternationalcollege',
          active: true,
        ),
        ProductResponseModel(
          type: "VEG",
          proudctImage:
              'https://tb-static.uber.com/prod/image-proc/processed_images/12a65c8086d9349620e7af6453fecd3a/859baff1d76042a45e319d1de80aec7a.jpeg',
          name: 'Product 2',
          price: 19.99,
          productId: 'texasinternationalcollege2',
          referenceSchool: 'texasinternationalcollege',
          active: true,
        ),
        ProductResponseModel(
          type: "NON",
          proudctImage:
              'https://tb-static.uber.com/prod/image-proc/processed_images/a306037b3802d6bada1729e55a8b016f/9b3aae4cf90f897799a5ed357d60e09d.jpeg',
          name: 'Samosa Achar',
          price: 19.99,
          productId: 'texasinternationalcollege3',
          referenceSchool: 'texasinternationalcollege',
          active: true,
        ),
        ProductResponseModel(
          type: "VEG",
          proudctImage:
              'https://d1ralsognjng37.cloudfront.net/d65ca498-dba0-4033-a21d-d550e567842c.jpeg',
          name: "Veg-Fried Rice",
          price: 60,
          productId: 'texasinternationalcollege4',
          referenceSchool: 'texasinternationalcollege',
          active: true,
        ),
        ProductResponseModel(
          type: "VEG",
          proudctImage:
              "https://media-cdn.tripadvisor.com/media/photo-m/1280/1b/57/52/cb/roti-and-tarkari-vegan.jpg",
          name: 'Roti Tarkari',
          price: 140,
          productId: 'texasinternationalcollege5',
          referenceSchool: 'texasinternationalcollege',
          active: true,
        ),
        // Add more products as needed
      ];
      uploadloading(true);
      for (var product in products) {
        await _firestore
            .collection(ApiEndpoints.productionProdcutCollection)
            .add(product.toJson()); // Use add method to generate document ID
      }
      uploadloading(false);
      Get.snackbar('Success', 'Products uploaded successfully');
    } catch (e) {
      uploadloading(false);
      Get.snackbar('Error', 'Failed to upload products: $e');
    }
  }
}
