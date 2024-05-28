import 'dart:developer';
import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:connect_canteen/app/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class CanteenHoldOrders extends GetxController {
  var isloading = false.obs;
  var holdLoading = false.obs;

//------------fetch the user orders---------------
  final orderRepository = GreatRepository();

//-----------------hold the user orders-----------
  Future<void> holdUserOrder(
      BuildContext context, String orderId, String date) async {
    try {
      holdLoading(true);

      final filters = {'id': orderId, 'orderType': 'regular'};
      final updateField = {'orderType': 'hold', 'holdDate': date};

      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        fetchHoldOrders();

        holdLoading(false);
      } else {
        log("Failed to add friend: ${response.message}");
        holdLoading(false);
      }
    } catch (e) {
      holdLoading(false);
      log('Error while adding friend: $e');
    } finally {
      holdLoading(false);
    }
  }

//-------------------get hold orders------------//
  final Rx<ApiResponse<OrderResponse>> holdOrderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchHoldOrders() async {
    try {
      isloading(true);

      final filters = {
        'checkout': 'false',
        'orderType': 'hold',
        // Add more filters as needed
      };
      holdOrderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.getFromDatabase(
          filters, OrderResponse.fromJson, ApiEndpoints.orderCollection);
      if (orderResult.status == ApiStatus.SUCCESS) {
        holdOrderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);
      }
    } catch (e) {
      isloading(false);

      log('Error while getting data: $e');
    } finally {
      isloading(false);
    }
  }

  //-------------to get the hold order report daily basis. --------
  final holdOrderRepository = GreatRepository();

  final Rx<ApiResponse<OrderResponse>> holdOrderReportResponse =
      ApiResponse<OrderResponse>.initial().obs;

  final RxMap<String, int> totalQuantityPerProduct = <String, int>{}.obs;
  var date = ''.obs;

  Future<void> fetchHoldMeal(int index, String date) async {
    fetchDailyHold(timeSlots[index], date);
  }

  Future<void> fetchDailyHold(String mealtime, String dates) async {
    try {
      isloading(true);
      final filters = mealtime == 'All'
          ? {
              'holdDate': dates,
              "orderType": 'hold'

              // Add more filters as needed
            }
          : {
              'holdDate': dates,
              "mealtime": mealtime,
              "orderType": 'hold'

              // Add more filters as needed
            };
      holdOrderReportResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await holdOrderRepository.getFromDatabase(
          filters, OrderResponse.fromJson, ApiEndpoints.orderCollection);

      if (orderResult.status == ApiStatus.SUCCESS) {
        holdOrderReportResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        // Calculate total quantity after fetching orders
        calculateTotalQuantity(orderResult.response!);
      }
    } catch (e) {
      log('Error while getting data: $e');
    } finally {
      isloading(false);
    }
  }

  final RxList<ProductQuantity> productQuantities = <ProductQuantity>[].obs;

  void calculateTotalQuantity(List<OrderResponse> orders) {
    totalQuantityPerProduct.clear();

    orders.forEach((order) {
      totalQuantityPerProduct.update(
        order.productName,
        (value) => value + order.quantity,
        ifAbsent: () => order.quantity,
      );
    });

    // Convert map to list of ProductQuantity objects
    productQuantities.value = totalQuantityPerProduct.entries
        .map((entry) => ProductQuantity(
              productName: entry.key,
              totalQuantity: entry.value,
            ))
        .toList();
  }
}
