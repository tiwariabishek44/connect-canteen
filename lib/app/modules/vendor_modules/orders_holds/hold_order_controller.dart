import 'dart:developer';
import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/repository/order_checout_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';
import 'package:nepali_utils/nepali_utils.dart';

class CanteenHoldOrders extends GetxController {
  var isOrderFetch = false.obs;
  var isloading = false.obs;
  var holdLoading = false.obs;
  final groupcod = TextEditingController();
  var updateGroupCode = ''.obs;

//------------fetch the user orders---------------
  final orderRepository = GreatRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchOrders(String groupId) async {
    try {
      log(groupId);
      isloading(true);

      orderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.doGetFromDatabase(
          groupId, OrderResponse.fromJson);
      if (orderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);
        log('----orders is been fetch');

        log("this is the all product response  " +
            orderResponse.value.response!.length.toString());
        if (orderResponse.value.response!.length != 0) {
          isOrderFetch(true);
          updateGroupCode.value = groupId;
        } else {
          isOrderFetch(false);
        }
      }
    } catch (e) {
      isloading(false);

      log('Error while getting data: $e');
    } finally {
      isloading(false);
    }
  }

//-----------------hold the user orders-----------
  Future<void> holdUserOrder(
      BuildContext context, String orderId, String date) async {
    try {
      holdLoading(true);

      final filters = {'id': orderId};
      final updateField = {'date': '', 'orderType': 'hold', 'holdDate': date};

      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        log("Hold Succesfully");
        fetchHoldOrders();
        // ignore: use_build_context_synchronously
        CustomSnackbar.showSuccess(
            context, "Your order is been hold  condition");

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
      final orderResult = await orderRepository.doGetFromDatabase(
          filters, OrderResponse.fromJson);
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
}
