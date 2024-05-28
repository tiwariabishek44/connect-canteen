import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:connect_canteen/app/models/student_fine_Response.dart';
import 'package:connect_canteen/app/models/users_model.dart';

import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/repository/pay_fine_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:nepali_utils/nepali_utils.dart';

class StudnetFineController extends GetxController {
  var loading = false.obs;
  var fineApply = false.obs;

  var isFetchLoading = false.obs;
  final storage = GetStorage();
  final PayFineRepository fineRepository = PayFineRepository();
  final Rx<ApiResponse<StudentFineResponse>> fineResponse =
      ApiResponse<StudentFineResponse>.initial().obs;

  final holdOrderController = Get.put(CanteenHoldOrders());
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> stateUpdate(
    BuildContext context,
    String orderId,
  ) async {
    try {
      log("ti is the order hold");
      loading(true);

      DateTime now = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final dat = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      holdOrderController.holdUserOrder(context, orderId, dat).then((value) {
        loading(false);
      });
    } catch (e) {
      loading(false);
      log('Error while adding friend: $e');
    }
  }

//--------------fetch the user data---------------
  final GreatRepository userDataRepository = GreatRepository();
  final Rx<ApiResponse<UserDataResponse>> userDataResponse =
      ApiResponse<UserDataResponse>.initial().obs;
  Future<void> fetchUserData(String userId) async {
    try {
      isFetchLoading(true);

      final filter = {
        'userid': userId,
        // Add more filters as needed
      };
      userDataResponse.value = ApiResponse<UserDataResponse>.loading();
      final userDataResult = await userDataRepository.getFromDatabase(
          filter, UserDataResponse.fromJson, ApiEndpoints.studentCollection);
      if (userDataResult.status == ApiStatus.SUCCESS) {
        userDataResponse.value =
            ApiResponse<UserDataResponse>.completed(userDataResult.response);
        isFetchLoading(false);

        log(userDataResponse.value.response!.first.classes);
      }
      isFetchLoading(false);
    } catch (e) {
      isFetchLoading(false);

      log('Error while getting data: $e');
    } finally {
      isFetchLoading(false);
    }
  }
}
