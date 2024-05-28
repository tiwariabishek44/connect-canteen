import 'dart:developer';

import 'package:connect_canteen/app/config/prefs.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/repository/order_requirement_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class OrderRequirementContoller extends GetxController {
  final OrderRequirementRepository orderRequirementRepository =
      OrderRequirementRepository();

  final Rx<ApiResponse<OrderResponse>> requirmentResponse =
      ApiResponse<OrderResponse>.initial().obs;

  final RxMap<String, int> totalQuantityPerProduct = <String, int>{}.obs;
  var date = ''.obs;

  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchMeal(int index, String date) async {
    fetchRequirement(timeSlots[index], date);
  }

  var orderRequirementLoded = false.obs;
  Future<void> fetchRequirement(String mealtime, String dates) async {
    try {
      isLoading(true);
      requirmentResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult =
          await orderRequirementRepository.getOrderRequirement(mealtime, dates);
      if (orderResult.status == ApiStatus.SUCCESS) {
        requirmentResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        // Calculate total quantity after fetching orders
        calculateTotalQuantity(orderResult.response!);
        isLoading(false);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      log('Error while getting data: $e');
    }
  }

  final RxList<ProductQuantity> productQuantities = <ProductQuantity>[].obs;

  void calculateTotalQuantity(List<OrderResponse> orders) {
    totalQuantityPerProduct.clear();
    orderRequirementLoded(false);

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

    if (productQuantities.length > 0) {
      orderRequirementLoded(true);
    }
  }
}

class ProductQuantity {
  final String productName;

  final int totalQuantity;

  ProductQuantity({
    required this.productName,
    required this.totalQuantity,
  });
}
