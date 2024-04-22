import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/modules/student_modules/home/product_controller.dart';
import 'package:connect_canteen/app/repository/product_update_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';

class PriceUpdateController extends GetxController {
  final price = TextEditingController();
  final productLive = true.obs;
  var isloading = false.obs;
  final homepagecontroller = Get.put(ProductController());
  final priceFormKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

//-------student order checkout------------//
  final checkoutReository =
      ProductUpdateRepository(); // Instantiate AddFriendRepository

  Future<void> stateUpdate(
      BuildContext context, String productId, bool state) async {
    try {
      isloading(true);
      final response =
          await checkoutReository.productStateUpdate(productId, state);
      if (response.status == ApiStatus.SUCCESS) {
        isloading(false);
        homepagecontroller.fetchProducts();
      } else {
        isloading(false);
        log("Failed to add friend: ${response.message}");
      }
    } catch (e) {
      isloading(false);
      log('Error while adding friend: $e');
    } finally {
      isloading(false);
    }
  }

  Future<void> priceSubmit(
    BuildContext context,
    String productId,
  ) async {
    if (priceFormKey.currentState!.validate()) {
      try {
        isloading(true);
        final response = await checkoutReository.priceUPdate(
            productId, double.parse(price.text.trim()));
        if (response.status == ApiStatus.SUCCESS) {
          isloading(false);
          homepagecontroller.fetchProducts();
        } else {
          isloading(false);
          log("Failed to add friend: ${response.message}");
        }
      } catch (e) {
        isloading(false);
        log('Error while adding friend: $e');
      } finally {
        isloading(false);
      }
    }
  }

  String? priceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter the Amount';
    }

    // Return null if the entered email is valid
    return null;
  }
}
