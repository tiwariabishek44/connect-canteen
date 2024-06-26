import 'dart:developer';

import 'package:connect_canteen/app/config/prefs.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/repository/class_report_repository.dart';
import 'package:connect_canteen/app/repository/order_requirement_repository.dart';
import 'package:connect_canteen/app/repository/remaning_orders_reository.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class ClassReportController extends GetxController {
  final ClassReportRepository classReportRepository = ClassReportRepository();

  final Rx<ApiResponse<OrderResponse>> classReportResponse =
      ApiResponse<OrderResponse>.initial().obs;

  final RxMap<String, int> totalQuantityPerRemaningProduct =
      <String, int>{}.obs;

  var date = ''.obs;

  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchMeal(int index, String date) async {
    fetchRequirement(timeSlots[index], date);
  }

  Future<void> fetchRequirement(String mealtime, String dates) async {
    try {
      isLoading(true);
      classReportResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult =
          await classReportRepository.getClassReport(mealtime, dates);
      if (orderResult.status == ApiStatus.SUCCESS) {
        classReportResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        // Calculate total quantity after fetching orders
        calculateTotalQuantity(orderResult.response!);
      }
    } catch (e) {
      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }

  final RxList<ProductQuantity> productQuantities = <ProductQuantity>[].obs;

  void calculateTotalQuantity(List<OrderResponse> orders) {
    totalQuantityPerRemaningProduct.clear();

    orders.forEach((order) {
      totalQuantityPerRemaningProduct.update(
        order.classs,
        (value) => value + order.quantity,
        ifAbsent: () => order.quantity,
      );
    });

    // Convert map to list of ProductQuantity objects
    productQuantities.value = totalQuantityPerRemaningProduct.entries
        .map((entry) => ProductQuantity(
              className: entry.key,
              price: calculateTotalPrice(entry.key, orders), // Calculate price
              totalQuantity: entry.value,
            ))
        .toList();
  }

  int calculateTotalPrice(String className, List<OrderResponse> orders) {
    return orders
        .where((order) => order.classs == className)
        .map((order) => order.quantity * order.price)
        .fold(0, (previousValue, price) => previousValue + price.toInt());
  }

//-----------------for the class remanign orders ---------------
  final Rx<ApiResponse<OrderResponse>> remaningOrderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  final ClassReportRepositorys classReportRepositorys =
      ClassReportRepositorys();
  final RxMap<String, int> ctotalQuantityPerRemaningProduct =
      <String, int>{}.obs;

  Future<void> fetchRemaing(String dates) async {
    try {
      isLoading(true);
      remaningOrderResponse.value = ApiResponse<OrderResponse>.loading();
      final remaningOrderResult =
          await classReportRepositorys.getRemaningOrders(dates);
      if (remaningOrderResult.status == ApiStatus.SUCCESS) {
        remaningOrderResponse.value =
            ApiResponse<OrderResponse>.completed(remaningOrderResult.response);

        // Calculate total quantity after fetching orders
        calculateRemaningQuantity(remaningOrderResult.response!);
      }
    } catch (e) {
      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }

  final RxList<ProductQuantity> remaningproductQuantities =
      <ProductQuantity>[].obs;

  void calculateRemaningQuantity(List<OrderResponse> orders) {
    ctotalQuantityPerRemaningProduct.clear();

    orders.forEach((order) {
      ctotalQuantityPerRemaningProduct.update(
        order.classs,
        (value) => value + order.quantity,
        ifAbsent: () => order.quantity,
      );
    });

    // Convert map to list of ProductQuantity objects
    remaningproductQuantities.value = ctotalQuantityPerRemaningProduct.entries
        .map((entry) => ProductQuantity(
              className: entry.key,
              price: calculateTotalPrice(entry.key, orders), // Calculate price
              totalQuantity: entry.value,
            ))
        .toList();
  }
}

class ProductQuantity {
  final String className;
  final int price;

  final int totalQuantity;

  ProductQuantity({
    required this.className,
    required this.price,
    required this.totalQuantity,
  });
}
