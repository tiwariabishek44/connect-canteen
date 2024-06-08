import 'dart:developer';

import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/order_succesfull.dart';
import 'package:connect_canteen/app1/repository/add_ordre_repository.dart';
import 'package:connect_canteen/app1/service/api_cilent.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:connect_canteen/app1/widget/loded_succesfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class AddOrderController extends GetxController {
  final AddOrderRepository orderRepository = AddOrderRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  var isLoading = false.obs;


  final transctionController = Get.put(TransctionController());

 
  var mealtime = ''.obs;
  var quantity = 1.obs;
  Future<void> addItemToOrder(BuildContext context,
      {required String customerImage,
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
      required String lastTime}) async {
    try {
      isLoading(true);
      DateTime now = DateTime.now();
      String productId =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';
      log("--------------this is the order time ${now}");

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final orderTime =
          DateFormat('HH:mm\'', 'en').format(nepaliDateTime);

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
        "scrhoolrefrenceid": scrhoolrefrenceid
      };

      orderResponse.value = ApiResponse<OrderResponse>.loading();

      final addOrderResult = await orderRepository.addOrder(newItem);

      if (addOrderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(addOrderResult.response);
            
        TransctionResponseMode transaction = TransctionResponseMode(
            userId: cid,
            userName: customer,
            schoolReference: 'texasinternationalcollege',
            className: classs,
            remarks: '${lastTime} /${productName}',
            transactionType: 'Purchase',
            amount: price,
            transactionDate: date,
            transctionTime: orderTime);
        await transctionController.uploadTransaction(transaction);
        LocalNotifications.showScheduleNotification(
            title: "Thank for placing your order!",
            body: "Your meal will be ready for pickup from the counter.",
            payload: "This is periodic data");

          
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
      // ignore: use_build_context_synchronously
      CustomSnackbar.error(
          context, 'Failed to add item to orders. Please try again later.');
    }
  }
}
