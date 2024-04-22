import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class OverflowController extends GetxController {
  final List<String> timeSlots = [
    "09:00",
    '10:30',
    '11:00'
  ]; // Define meal time slots globally

  var overflowMealTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    calculateOverflowMealTime(); // Call the method when the controller is initialized
  }

  void calculateOverflowMealTime() {
    overflowMealTime.value = '';
    DateTime currentDate = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    String formattedTime = DateFormat('HH:mm', 'en').format(nepaliDateTime);

    String currentMealTime = ''; // Initialize to an empty string

    // Iterate over timeSlots to find the current and next meal time
    for (int i = 0; i < timeSlots.length; i++) {
      String mealTime = timeSlots[i];

      // Check if currentTime is before the current meal time
      if (formattedTime.compareTo(mealTime) < 0) {
        // Set overflowMealTime to the previous meal time
        overflowMealTime.value = currentMealTime;
        break;
      }

      // Update currentMealTime
      currentMealTime = mealTime;
    }

    // If overflowMealTime is still empty, set it to the last meal time in timeSlots
    if (overflowMealTime.value.isEmpty) {
      overflowMealTime.value = timeSlots.last;
    }

    log(" this is the overflow meal time =========${overflowMealTime.value}");

    fetchOverflowOrders();
  }

// to calculate  the overflow meals list

  final orderRepository = GreatRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  var isloading = false.obs;
  var isOrderFetch = false.obs;

  Future<List<OverflowOrder>> fetchOverflowOrders() async {
    try {
      DateTime currentDate = DateTime.now();
      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
      String formattedDate =
          DateFormat('dd/MM/yyyy', 'en').format(nepaliDateTime);

      final filter = {
        'checkout': 'false',
        'mealtime': overflowMealTime.value,
        'date': formattedDate,
        'overFlowRead': 'false',
        // Add more filters as needed
      };

      final ApiResponse<OrderResponse> orderResult =
          await orderRepository.getFromDatabase(
              filter, OrderResponse.fromJson, ApiEndpoints.orderCollection);

      if (orderResult.status == ApiStatus.SUCCESS) {
        // Calculate overflow products and their quantities
        if (orderResult.response!.length != 0) {}
        return segregateOverflow(orderResult.response!);
      }
    } catch (e) {
      log('Error while getting data: $e');
    }
    return []; // Return an empty list if there's an error or no overflow orders
  }

  // Method to segregate overflow by productName with respective quantity
  List<OverflowOrder> segregateOverflow(List<OrderResponse> orders) {
    Map<String, int> overflowProducts = {};

    // Iterate through orders and segregate by productName with respective quantity
    for (OrderResponse order in orders) {
      final productName = order.productName;
      final quantity = order.quantity;

      // Check if productName or quantity is null before adding to the map
      if (productName != null && quantity != null) {
        if (overflowProducts.containsKey(productName)) {
          overflowProducts[productName] =
              overflowProducts[productName]! + quantity;
        } else {
          overflowProducts[productName] = quantity;
        }
      }
    }

    // Convert the map to a list of OverflowOrder objects
    List<OverflowOrder> overflowOrders = [];
    overflowProducts.forEach((productName, quantity) {
      overflowOrders.add(
          OverflowOrder(overflowOrderName: productName, quantity: quantity));
    });
    log(" this is the length of the overflow product ${overflowOrders.length}");

    return overflowOrders;
  }

// ----------------- mark as  read for the overflow order

  Future<void> markAsRead() async {
    try {
      DateTime currentDate = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      final filters = {
        'checkout': 'false',
        'orderType': 'regular',
        'mealtime': overflowMealTime.value,
        'date': formattedDate,
        'overFlowRead': 'false',
      };

      final updateField = {'overFlowRead': 'true'};

      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 4, 155, 82),
            content: Text('Your have seen the overflows'),
          ),
        );
      } else {
        log("Failed to add friend: ${response.message}");
      }
    } catch (e) {
      log('Error while adding friend: $e');
    }
  }
}

class OverflowOrder {
  final String overflowOrderName;
  final int quantity;

  OverflowOrder({required this.overflowOrderName, required this.quantity});
}
