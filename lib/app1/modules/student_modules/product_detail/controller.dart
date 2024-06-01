import 'dart:developer';

import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/wallet_controller.dart';
import 'package:connect_canteen/app1/repository/add_ordre_repository.dart';
import 'package:connect_canteen/app1/service/api_cilent.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class AddOrderController extends GetxController {
  final AddOrderRepository orderRepository = AddOrderRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  var isLoading = false.obs;

  final walletCotnroller = Get.put(WalletController());

  var orderDate = ''.obs;
  var mealtime = ''.obs;
  var orderHoldTime = ''.obs;
  var isorderStart = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkTimeAndSetVisibility();
  }

//---------to find the date --------

  void checkTimeAndSetVisibility() {
    // isorderStart.value = false;
    mealtime.value = '';
    DateTime currentDate = DateTime.now();
    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    int currentHour = currentDate.hour;

    if ((currentHour >= 15 && currentHour <= 23)) {
      // After 4 pm but not after 1 am (next day)
      NepaliDateTime tomorrow = nepaliDateTime.add(Duration(days: 1));
      // isorderStart.value = true;

      orderDate.value = DateFormat('dd/MM/yyyy\'', 'en').format(tomorrow);
    } else if (currentHour >= 0 && currentHour <= 6) {
      // 1 am or later
      // isorderStart.value = true;

      orderDate.value = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    }
  }

  Future<void> addDummyOrder(BuildContext context) async {
    await addItemToOrder(
      context,
      customerImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYEUsFtuTAZKoXiUZA0050A_MJ7gEY7k-YYg&s',
      classs: '12A',
      customer: 'Hari Bhadur',
      groupid: 'G001',
      cid: 'SEECPIJ67PfTQnMiI0G30p9PmU93',
      productName: 'Pizza',
      productImage:
          'https://merisehat.pk/_next/image?url=https%3A%2F%2Fms-images.s3.ap-southeast-1.amazonaws.com%2Fmedia%2FafWPDdFaI5KMS4jFoGq8NWOyRVeUvA9LbNixFbVc.jpg&w=1920&q=75',
      price: 100,
      quantity: 1,
      groupcod: '1426',
      checkout: 'false',
      mealtime: 'Lunch',
      date: orderDate.value,
      orderHoldTime: '12:30 PM',
      groupName: 'Thunder',
      scrhoolrefrenceid: 'texasinternationalcollege',
    );
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
    required String groupName,
    required String scrhoolrefrenceid,
  }) async {
    try {
      isLoading(true);
      DateTime now = DateTime.now();
      String productId =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';
      log("--------------this is the order time ${now}");

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final orderTime =
          DateFormat('HH:mm/dd/MM/yyyy\'', 'en').format(nepaliDateTime);

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
        LocalNotifications.showScheduleNotification(
            title: "Thank for placing your order!",
            body: "Your meal will be ready for pickup from the counter.",
            payload: "This is periodic data");

        await walletCotnroller.addTransaction(
          cid,
          Transactions(
            date: nepaliDateTime,
            name: 'Payment', // or penalty
            amount: 100,
            remarks: productName.toString(),
          ),
        );
        isLoading(false);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // rectangular corners
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    'Order Successful',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        );

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
