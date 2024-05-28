import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/repository/get_verify_order_repository.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../../../models/order_response.dart';

class VerifyController extends GetxController {
  final VerifyOrderRepository verifyOrderRepository = VerifyOrderRepository();

  final Rx<ApiResponse<OrderResponse>> verifyOrderResponse =
      ApiResponse<OrderResponse>.initial().obs;

  final RxMap<String, int> totalQuantityPerProduct = <String, int>{}.obs;

  final RxBool isLoading = false.obs;

  StreamSubscription? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
  }

  void calculateTotalQuantity(List<OrderResponse> orders) {
    totalQuantityPerProduct.clear();

    orders.forEach((order) {
      totalQuantityPerProduct.update(
        order.groupcod, // Update to use groupCode as the key
        (value) => value + order.quantity,
        ifAbsent: () => order.quantity,
      );
    });
  }

  Stream<Map<String, List<OrderResponse>>> groupOrdersStream() {
    DateTime currentDate = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

    final stream = FirebaseFirestore.instance
        .collection('order')
        .where('checkoutVerified', isEqualTo: 'true')
        .where('checkout', isEqualTo: 'false')
        .where('date', isEqualTo: formattedDate)
        .snapshots();

    return stream.map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderResponse.fromJson(doc.data()))
          .toList();
      calculateTotalQuantity(orders);
      return groupOrdersByGroupCode(orders);
    });
  }

  Map<String, List<OrderResponse>> groupOrdersByGroupCode(
      List<OrderResponse> orders) {
    final groupedOrders = <String, List<OrderResponse>>{};

    orders.forEach((order) {
      if (!groupedOrders.containsKey(order.groupcod)) {
        groupedOrders[order.groupcod] = [];
      }
      groupedOrders[order.groupcod]!.add(order);
    });

    return groupedOrders;
  }

  void closeStream() {
    _streamSubscription?.cancel();
  }

  var isloading = false.obs;
  var isOrderFetch = false.obs;
  var groupCod = ''.obs;

  final RxList<OrderResponse> orders = <OrderResponse>[].obs;
  final RxList<OrderResponse> vendorOrder = <OrderResponse>[].obs;
  var checkoutLoading = false.obs;

//------------fetch the user orders---------------
  final orderRepository = GreatRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchOrders() async {
    try {
      isloading(true);

      isOrderFetch(false);

      DateTime currentDate = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      final filter = {
        "groupcod": groupCod.value,
        'checkout': 'false',
        'orderType': 'regular',
        'date': formattedDate,
        'checkoutVerified': 'true'

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
    }
  }

  Future<void> checkoutOrder() async {
    try {
      checkoutLoading(true);
      DateTime currentDate = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      checkoutLoading(true);
      final filters = {
        "groupcod": groupCod.value,
        'checkout': 'false',
        'orderType': 'regular',
        'date': formattedDate,
        'checkoutVerified': 'true'

        // Add more filters as needed
      };
      final updateField = {"checkout": 'true'};

      final response = await orderRepository.doUpdate(
          filters, updateField, ApiEndpoints.orderCollection);
      if (response.status == ApiStatus.SUCCESS) {
        log(" this is checkout update");
        fetchOrders();
        checkoutLoading(false);
      } else {
        checkoutLoading(false);
      }
    } catch (e) {
      checkoutLoading(false);
      log('Error while adding friend: $e');
    }
  }
}
