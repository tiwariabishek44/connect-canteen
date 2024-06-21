import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenueAddController extends GetxController {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void doAdd() {
    if (_formKey.currentState?.validate() ?? false) {
      addProduct();
    }
  }

  var loading = false.obs;
  Future<void> addProduct() async {
    loading.value = true;
    String productId = _firestore
        .collection(ApiEndpoints.productionProdcutCollection)
        .doc()
        .id;

    ProductResponseModel newProduct = ProductResponseModel(
      productId: productId,
      name: productNameController.text,
      proudctImage: '',
      price: double.parse(priceController.text),
      active: true, // Defaulting to active on creation
      referenceSchool: "texasinternationalcollege",
      type: '',
    );

    try {
      await _firestore
          .collection(ApiEndpoints.productionProdcutCollection)
          .doc(productId)
          .set(newProduct.toJson());
      loading.value = false;
      CustomSnackbar.success(Get.context!, "Product added Succesfully");

      // Clear the form fields after successful submission
      productNameController.clear();
      priceController.clear();
    } catch (e) {
      loading.value = false;

      CustomSnackbar.error(
          Get.context!, 'Failed to add product. Please try again.');
    }
  }

  Future<void> itemDelete(String id) async {
    loading.value = true;

    try {
      await _firestore
          .collection(ApiEndpoints.productionProdcutCollection)
          .doc(id)
          .delete();
      loading.value = false;
      CustomSnackbar.success(Get.context!, "Product deleted successfully");
    } catch (e) {
      loading.value = false;
      CustomSnackbar.error(
          Get.context!, 'Failed to delete product. Please try again.');
    }
  }

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  @override
  void onClose() {
    productNameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
