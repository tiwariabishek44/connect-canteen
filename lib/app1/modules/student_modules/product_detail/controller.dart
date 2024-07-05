import 'dart:developer';

import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/transction_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/order_succesfull.dart';
import 'package:connect_canteen/app1/repository/add_ordre_repository.dart';
import 'package:connect_canteen/app1/service/api_cilent.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:connect_canteen/app1/widget/order_succesufll.dart';
import 'package:connect_canteen/app1/widget/payment_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrderController extends GetxController {
  final AddOrderRepository orderRepository = AddOrderRepository();
  final paymentType = 'wallet'.obs;
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  var isLoading = false.obs;

  final transctionController = Get.put(TransctionController());

  var mealtime = ''.obs;
  var quantity = 1.obs;
  Future<void> addItemToOrder(
    BuildContext context, {
    required String orderby,
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
    required String groupName,
    required String scrhoolrefrenceid,
  }) async {
    try {
      DateTime now = DateTime.now();
      String productId =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';
      log("--------------this is the order time ${now}");

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final orderTime = DateFormat('HH:mm\'', 'en').format(nepaliDateTime);

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
        'orderTime': orderTime,
        "customerImage": customerImage,
        "orderHoldTime": orderHoldTime,
        'checkoutVerified': 'false',
        "groupName": groupName,
        'coinCollect': 'false',
        'overFlowRead': 'false',
        "scrhoolrefrenceid": scrhoolrefrenceid,
        'isCahsed': orderby,
        // 'isCahsed': paymentType.value == 'cash' ? 'true' : 'false',
      };

      orderResponse.value = ApiResponse<OrderResponse>.loading();

      final addOrderResult = await orderRepository.addOrder(newItem);

      if (addOrderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(addOrderResult.response);

        LocalNotifications.showScheduleNotification(
            title: "Thank for placing your order!",
            body: "Your meal will be ready for pickup from the counter.",
            payload: "This is periodic data");
        Get.off(() => OrderSuccesfullPage(),
            transition: Transition.cupertinoDialog);

        isLoading(false);

        // Navigate to home page or perform necessary actions upon successful login
      } else {
        isLoading(false);

        orderResponse.value = ApiResponse<OrderResponse>.error(
            addOrderResult.message ?? 'Error during product create Failed');
        // ignore: use_build_context_synchronously
        CustomSnackbar.error(context, orderResponse.value.toString());
      }
    } catch (e) {
      isLoading(false);

      // If an error occurs during the process, you can handle it here
      log('Error adding item to orders: $e');
      CustomSnackbar.error(
          context, 'Failed to add item to orders. Please try again later.');
    }
  }

  Future<bool> isPermission(String customerId) async {
    try {
      DateTime nowUtc = DateTime.now().toUtc();
      DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
      final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

      // Make a query to Firestore to fetch orders for the specified customer
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(ApiEndpoints.productionOrderCollection)
          .where('cid', isEqualTo: customerId)
          .where('checkout', isEqualTo: 'false')
          .where('date', isEqualTo: todayDate)
          .where('orderType', isEqualTo: 'regular')
          .get();

      // Check if the length of the resulting list is 2 or greater
      if (querySnapshot.docs.length >= 2) {
        return false; // If 2 or greater, return false
      } else {
        return true; // If less than 2, return true
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error: $e');
      return false; // Return false in case of an error
    }
  }

  // orer loign
}
