import 'dart:developer';
import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:connect_canteen/app/widget/payment_succesfull.dart';
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
  var calenderDate = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetchOrders();
    fetchHoldOrders();
  }

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

        if (orderResponse.value.response!.length != 0) {
          orderLoded(true);
          calculateTotalAmount(orderResponse.value.response!);
        } else {
          totalprice.value = 0.0;
          orderLoded(false);
        }
      }
    } catch (e) {
      orderLoded(false);
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }

  var totalprice = 0.0.obs;
  // Method to calculate total amount (total price of the order)
  double calculateTotalAmount(List<OrderResponse> orders) {
    double totalAmount = 0;
    for (OrderResponse order in orders) {
      totalAmount += (order.price * order.quantity);
    }

    totalprice.value = totalAmount;
    return totalAmount;
  }

//-----------------hold the user orders-----------
  Future<void> holdUserOrder(String orderId, String date) async {
    try {
      holdLoading(true);
      Get.back();
      final filters = {'id': orderId};
      final updateField = {'orderType': 'hold', 'holdDate': date};
      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        fetchOrders();
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
      Get.back();

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
        showDialog(
            barrierColor: Color.fromARGB(255, 73, 72, 72).withOpacity(0.5),
            context: Get.context!,
            builder: (BuildContext context) {
              return CustomPopup(
                message: 'Succesfully Schedule',
                onBack: () {
                  Get.back();
                },
              );
            });
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
