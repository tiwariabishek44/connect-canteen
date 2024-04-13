import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class VendorOrderController extends GetxController {
  var isloading = false.obs;
  var isOrderFetch = false.obs;
  var groupCod = ''.obs;

  final logincontroller = Get.put(LoginController());
  final RxList<OrderResponse> orders = <OrderResponse>[].obs;
  final RxList<OrderResponse> vendorOrder = <OrderResponse>[].obs;
  var checkoutLoading = false.obs;
  var isgroup = true.obs;
  final salseController = Get.put(SalsesController());

//------------fetch the user orders---------------
  final orderRepository = GreatRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchOrders(String groupCod) async {
    log(groupCod);
    try {
      DateTime currentDate = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      isloading(true);
      final filter = {
        "groupcod": groupCod,
        'checkout': 'false',
        'orderType': 'regular',
        'date': formattedDate,

        // Add more filters as needed
      };
      orderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.getFromDatabase(
          filter, OrderResponse.fromJson, ApiEndpoints.orderCollection);
      if (orderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);
        isloading(false);

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

  Future<void> checkoutOrder(String pin) async {
    try {
      checkoutLoading(true);
      final filters = {
        '${isgroup.value ? "groupcod" : 'id'}': pin,
        'orderType': 'regular',
      };
      final updateField = {'checkout': 'true'};

      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        log("checkout Succesfully");

        fetchOrders(groupCod.value);
        salseController.fetchTotalSales();

        checkoutLoading(false);
        isOrderFetch(false);
      } else {
        log("Failed to add friend: ${response.message}");
        checkoutLoading(false);
      }
    } catch (e) {
      checkoutLoading(false);
      log('Error while adding friend: $e');
    } finally {
      checkoutLoading(false);
    }
  }
}
