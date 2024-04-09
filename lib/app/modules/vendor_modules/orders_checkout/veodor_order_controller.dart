import 'dart:developer';

import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/order_checout_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class VendorOrderController extends GetxController {
  var isloading = false.obs;
  var isOrderFetch = false.obs;
  final logincontroller = Get.put(LoginController());
  final groupcod = TextEditingController();
  final RxList<OrderResponse> orders = <OrderResponse>[].obs;
  final RxList<OrderResponse> vendorOrder = <OrderResponse>[].obs;
  var checkoutLoading = false.obs;
  var isgroup = true.obs;
  final salseController = Get.put(SalsesController());
  @override
  void onReady() {
    super.onReady();
    orders.clear(); // Clear the orders list when the screen is initialized
  }

  @override
  void onInit() {
    super.onInit();
    log("this is delete");
  }

  @override
  void dispose() {
    groupcod.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

//------------fetch the user orders---------------
  final orderRepository = CheckoutRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchOrders(String groupId) async {
    try {
      DateTime currentDate = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      isloading(true);
      final filter = {
        "groupcod": "1429",
        'checkout': 'false',
        'orderType': 'regular',
        'date': formattedDate,

        // Add more filters as needed
      };
      orderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.getOrders(filter);
      if (orderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);
        log('----orders is been fetch');
        isloading(false);

        log("this is the all product response  " +
            orderResponse.value.response!.length.toString());
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

//-------student order checkout------------//
  final checkoutReository =
      CheckoutRepository(); // Instantiate AddFriendRepository

  Future<void> checkoutGroupOrder(BuildContext context, String groupcod) async {
    try {
      checkoutLoading(true);
      final response = await checkoutReository.orderCheckout(groupcod);
      if (response.status == ApiStatus.SUCCESS) {
        log("checkout Succesfully");

        fetchOrders(groupcod);
        salseController.fetchTotalSales();
        CustomSnackbar.showSuccess(context, "CheckOut Succesfully");
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
  //-------------single checkout--------------

  Future<void> checkoutSingleOrder(BuildContext context, String orderid) async {
    try {
      checkoutLoading(true);
      final response = await checkoutReository.singleOrderCheckout(orderid);
      if (response.status == ApiStatus.SUCCESS) {
        log("checkout Succesfully");

        fetchOrders(groupcod.text);
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
