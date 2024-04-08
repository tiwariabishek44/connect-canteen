import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:connect_canteen/app/models/student_fine_Response.dart';
import 'package:connect_canteen/app/models/users_model.dart';

import 'package:connect_canteen/app/modules/vendor_modules/orders_holds/hold_order_controller.dart';
import 'package:connect_canteen/app/repository/get_userdata_repository.dart';
import 'package:connect_canteen/app/repository/pay_fine_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:nepali_utils/nepali_utils.dart';

class StudnetFineController extends GetxController {
  var loading = false.obs;

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
    String userId,
    int oldFine,
    int newFine,
    int score,
  ) async {
    try {
      loading(true);
      DateTime now = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final dat = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      int finalScore = score; // Initialize finalScore with the provided score

      // Check if score is greater than 0
      if (score > 0) {
        finalScore--; // Decrement finalScore by 1
      } else {
        finalScore = 0; // Set finalScore to 0 if score is already 0
      }

      // Perform further operations with finalScore as needed

      final newUpdate = {
        "studentScore": finalScore,
        'fineAmount': oldFine + newFine
      };
      final response =
          await userDataRepository.userDataUpdate(userId, newUpdate);
      if (response.status == ApiStatus.SUCCESS) {
        loading(false);

        holdOrderController.holdUserOrder(context, orderId, dat);

        fetchUserData(userId);
      } else {
        loading(false);
        log("Failed to add friend: ${response.message}");
      }
    } catch (e) {
      loading(false);
      log('Error while adding friend: $e');
    } finally {
      loading(false);
      // Any cleanup code can be placed here
    }
  }

//--------------fetch the user data---------------
  final UserDataRepository userDataRepository = UserDataRepository();
  final Rx<ApiResponse<UserDataResponse>> userDataResponse =
      ApiResponse<UserDataResponse>.initial().obs;
  Future<void> fetchUserData(String userId) async {
    try {
      isFetchLoading(true);
      userDataResponse.value = ApiResponse<UserDataResponse>.loading();
      final userDataResult = await userDataRepository.getUserData(
        {
          'userid': userId,
          // Add more filters as needed
        },
      );
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
