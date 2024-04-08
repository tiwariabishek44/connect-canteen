import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/models/student_fine_Response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/get_userdata_repository.dart';
import 'package:connect_canteen/app/repository/pay_fine_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:connect_canteen/app/widget/custom_snackbar.dart';
import 'package:nepali_utils/nepali_utils.dart';

class FineController extends GetxController {
  var loading = false.obs;
  var fineLoading = false.obs;
  final loginController = Get.put(LoginController());

  final storage = GetStorage();
  final PayFineRepository fineRepository = PayFineRepository();
  final Rx<ApiResponse<StudentFineResponse>> fineResponse =
      ApiResponse<StudentFineResponse>.initial().obs;
  @override
  void onInit() {
    super.onInit();
    fetchFines();
  }

  void change() {
    loading.value = !loading.value;
  }

  Future<void> payFine(
    BuildContext context, {
    required String studentId,
    required int fineAmount,
  }) async {
    try {
      loading(true);
      DateTime now = DateTime.now();

      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
      final dat = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      final newFine = {
        'studentId': studentId,
        'fineAmount': fineAmount,
        'date': dat,
      };

      fineResponse.value = ApiResponse<StudentFineResponse>.loading();

      final fineResult = await fineRepository.payFine(newFine);

      if (fineResult.status == ApiStatus.SUCCESS) {
        fineResponse.value =
            ApiResponse<StudentFineResponse>.completed(fineResult.response);

        stateUpdate(context, studentId);

        loading(false);
      } else {
        loading(false);
        fineResponse.value = ApiResponse<StudentFineResponse>.error(
            fineResult.message ?? 'Error during product create Failed');
      }
    } catch (e) {
      loading(false);
      // If an error occurs during the process, you can handle it here
      log('Error adding item to orders: $e');
      // ignore: use_build_context_synchronously
    }
  }

//-------student fine update ------------//
  final userDataRepository =
      UserDataRepository(); // Instantiate AddFriendRepository

  Future<void> stateUpdate(
    BuildContext context,
    String userId,
  ) async {
    try {
      final newFine = {'fineAmount': 0};
      final response = await userDataRepository.userDataUpdate(userId, newFine);
      if (response.status == ApiStatus.SUCCESS) {
        CustomSnackbar.showSuccess(context, "CheckOut Succesfully");
        await refreshData();
      } else {
        log("Failed to add friend: ${response.message}");
      }
    } catch (e) {
      log('Error while adding friend: $e');
    } finally {}
  }

  //---------------Get Student fines------------

  final PayFineRepository allProductRepository = PayFineRepository();
  final Rx<ApiResponse<StudentFineResponse>> studentFinesResponse =
      ApiResponse<StudentFineResponse>.initial().obs;
  var fineLoaded = false.obs;
  Future<void> fetchFines() async {
    try {
      fineLoaded(false);
      fineLoading(true);
      studentFinesResponse.value = ApiResponse<StudentFineResponse>.loading();
      final allProductResult = await allProductRepository.getFines(
        storage.read(userId),
      );
      if (allProductResult.status == ApiStatus.SUCCESS) {
        studentFinesResponse.value = ApiResponse<StudentFineResponse>.completed(
            allProductResult.response);
        if (studentFinesResponse.value.response!.length != 0) {
          fineLoaded(true);
        }

        fineLoading(false);
      }
    } catch (e) {
      fineLoading(false);
      log('Error while getting data: $e');
    }
  }

//-----------to refresh.
  Future<void> refreshData() async {
    // Fetch data based on the selected category
    await Future.delayed(Duration(seconds: 0));
    await loginController.fetchUserData();
    Future.delayed(Duration(seconds: 2), () async {
      log(" this is insed the refres =============================---------------");

      await fetchFines();
      log(" ------------this is insed the refres =============================---------------");
    });
  }
}
