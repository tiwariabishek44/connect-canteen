import 'dart:developer';
import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';
import 'package:nepali_utils/nepali_utils.dart';

class OrderController extends GetxController {
  final loginController = Get.put(LoginController());
  var isLoading = false.obs;
  var holdLoading = false.obs;
  var orderLoded = false.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    void checkTimeAndSetDate() {
      DateTime currentDate = DateTime.now();
      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      dat.value = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    }

    fetchOrders();
    fetchHoldOrders();

    log("----ORDER CONTROLLER IS INITILIZE");
  }

  var dat = ''.obs;

//------------fetch the user orders---------------
  final orderRepository = GreatRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchOrders() async {
    try {
      isLoading(true);

      final filters = {
        "groupid":
            loginController.userDataResponse.value.response!.first.groupid,
        'checkout': 'false',
        'orderType': 'regular',

        // Add more filters as needed
      };
      orderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.getFromDatabase(
          filters, OrderResponse.fromJson, ApiEndpoints.orderCollection);
      if (orderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        orderResponse.value.response!.length != 0
            ? orderLoded(true)
            : orderLoded(false);
      }
    } catch (e) {
      orderLoded(false);
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }

//-----------------hold the user orders-----------
  Future<void> holdUserOrder(String orderId, String date) async {
    try {
      holdLoading(true);
      final filters = {'id': orderId};
      final updateField = {'date': '', 'orderType': 'hold', 'holdDate': date};
      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        log("checkout Succesfully");
        fetchOrders();
        fetchHoldOrders();
        // ignore: use_build_context_synchronously
        CustomSnackbar.showSuccess(
            Get.context!, "Your order is been hold  condition");
        Get.back();

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
      isLoading(true);

      final filters = {
        "cid": storage.read(userId),
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
        log('----orders is been fetch');

        log("this is the all product response  " +
            holdOrderResponse.value.response!.length.toString());
      }
    } catch (e) {
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }

//-----------------schedule the hold order----------------//

  Future<void> scheduleHoldOrders(
      BuildContext context, String orderId, String date) async {
    try {
      holdLoading(true);

      final filters = {'id': orderId};

      final updateField = {
        'date': date,
        'orderType': 'regular',
      };
      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        log("checkout Succesfully");
        fetchOrders();
        fetchHoldOrders();
        // ignore: use_build_context_synchronously
        CustomSnackbar.showSuccess(context, "Your order is been schedule");
        Get.back();

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
}
