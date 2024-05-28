import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/models/product_model.dart';
import 'package:connect_canteen/app/repository/all_product_respository.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var productLoaded = false.obs;

  final storage = GetStorage();
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  final AllProductRepository allProductRepository = AllProductRepository();
  final Rx<ApiResponse<Product>> allProductResponse =
      ApiResponse<Product>.initial().obs;
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      productLoaded(false);
      allProductResponse.value = ApiResponse<Product>.loading();
      final allProductResult = await allProductRepository.getallproducts(
        storage.read(userType) == student ? true : false,
      );
      if (allProductResult.status == ApiStatus.SUCCESS) {
        allProductResponse.value =
            ApiResponse<Product>.completed(allProductResult.response);

        if (allProductResponse.value.response!.length > 0) {
          productLoaded(true);
        }
      }
    } catch (e) {
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.productId)
          .set(product.toJson());
      Get.snackbar('Success', 'Product uploaded successfully');
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload product: $e');
    }
  }
}
