import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';

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

//------------fetch the user orders---------------
  final orderRepository = GreatRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchOrders(String date) async {
    try {
      isloading(true);
      final filter = {
        "classs": className.value,
        "date": date,
        'orderType': 'regular',
        "checkout": "false",

        // Add more filters as needed
      };

      orderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.getFromDatabase(
          filter, OrderResponse.fromJson, ApiEndpoints.orderCollection);
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
