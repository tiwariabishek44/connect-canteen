import 'dart:developer';

import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:connect_canteen/app/repository/add_order_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AddProductController extends GetxController {
  final orderController = Get.put(OrderController());
  final AddOrderRepository orderRepository = AddOrderRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  var isLoading = false.obs;

  var orderDate = ''.obs;
  var mealtime = ''.obs;
  var orderHoldTime = ''.obs;
  var isorderStart = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkTimeAndSetVisibility();
  }

//---------to find the date --------

  void checkTimeAndSetVisibility() {
    isorderStart.value = false;
    mealtime.value = '';
    DateTime currentDate = DateTime.now();
    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    int currentHour = currentDate.hour;

    if ((currentHour >= 15 && currentHour <= 23) ||
        (currentHour >= 0 && currentHour < 1)) {
      // After 4 pm but not after 1 am (next day)
      NepaliDateTime tomorrow = nepaliDateTime.add(Duration(days: 1));
      isorderStart.value = true;

      orderDate.value = DateFormat('dd/MM/yyyy\'', 'en').format(tomorrow);

      log("this is he date " + orderDate.value);
    } else if (currentHour >= 1 && currentHour <= 8) {
      // 1 am or later
      isorderStart.value = true;

      orderDate.value = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      log(orderDate.value);
    }
  }

  Future<void> addItemToOrder(
    BuildContext context, {
    required String customerImage,
    required String classs,
    required String customer,
    required String groupid,
    required String cid,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
    required String groupcod,
    required String checkout,
    required String mealtime,
    required String date,
    required String orderHoldTime,
  }) async {
    try {
      isLoading(true);
      DateTime now = DateTime.now();
      String productId =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';
      log("--------------this is the order time ${now}");

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final dat = DateFormat('HH:mm/dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      final newItem = {
        "id": '${productId + customer + productName}',
        "mealtime": mealtime,
        "classs": classs,
        "date": date,
        "checkout": 'false',
        "customer": customer,
        "groupcod": groupcod,
        "groupid": groupid,
        "cid": cid,
        "productName": productName,
        "price": price,
        "quantity": quantity,
        "productImage": productImage,
        "orderType": 'regular',
        "holdDate": '',
        'orderTime': dat,
        "customerImage": customerImage,
        "orderHoldTime": orderHoldTime,
      };

      orderResponse.value = ApiResponse<OrderResponse>.loading();

      log("--------------product image");
      final addOrderResult = await orderRepository.addOrder(newItem);

      if (addOrderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(addOrderResult.response);
        log("the order has been placed");
        orderController.fetchOrders();
        isLoading(false);
        LocalNotifications.showScheduleNotification(
            payload: "This is periodic data");
        Get.to(
            () => PaymentSuccessPage(
                  amountPaid: price.toInt().toString(),
                ),
            transition: Transition.rightToLeft,
            duration: duration);

        // Navigate to home page or perform necessary actions upon successful login
      } else {
        isLoading(false);

        orderResponse.value = ApiResponse<OrderResponse>.error(
            addOrderResult.message ?? 'Error during product create Failed');
        // ignore: use_build_context_synchronously
        CustomSnackbar.showFailure(context, orderResponse.value.toString());
      }
    } catch (e) {
      isLoading(false);

      // If an error occurs during the process, you can handle it here
      log('Error adding item to orders: $e');
      // ignore: use_build_context_synchronously
      CustomSnackbar.showFailure(
          context, 'Failed to add item to orders. Please try again later.');
    }
  }
}
