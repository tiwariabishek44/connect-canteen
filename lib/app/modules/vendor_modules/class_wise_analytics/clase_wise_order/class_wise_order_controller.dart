import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/get_user_order_repository.dart';
import 'package:connect_canteen/app/repository/order_checout_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';

class ClassWiseOrderController extends GetxController {
  var isloading = false.obs;
  var isOrderFetch = false.obs;
  final logincontroller = Get.put(LoginController());
  final groupcod = TextEditingController();
  final RxList<OrderResponse> orders = <OrderResponse>[].obs;
  final RxList<OrderResponse> vendorOrder = <OrderResponse>[].obs;
  var checkoutLoading = false.obs;
  var isgroup = true.obs;
  var className = ''.obs;

  @override
  void onReady() {
    super.onReady();
    orders.clear(); // Clear the orders list when the screen is initialized
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    groupcod.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

//------------fetch the user orders---------------
  final orderRepository = CheckoutRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchOrders() async {
    try {
      isloading(true);
      final filter = {
        "classs": className.value,
        'checkout': 'false',
        'orderType': 'regular',

        // Add more filters as needed
      };

      orderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.getOrders(filter);
      if (orderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        isloading(false);
        log("--------------we try to fetch the  orders ${className.value}");

        orderResponse.value.response!.length != 0
            ? isOrderFetch(true)
            : isOrderFetch(false);
      }
    } catch (e) {
      isloading(false);

      log('Error while getting data: $e');
    } finally {
      isloading(false);
    }
  }
}
