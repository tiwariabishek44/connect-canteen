import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/student_balance_model.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/add_balance_repository.dart';
import 'package:connect_canteen/app/repository/get_friend_list_repository.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class StudentBalanceController extends GetxController {
  final loginController = Get.put(LoginController());
  var fetchLoading = false.obs;

  final studentRepo = GetFriendRepository();
  final Rx<ApiResponse<UserDataResponse>> friendListResponse =
      ApiResponse<UserDataResponse>.initial().obs;
  Future<void> fetchStudents() async {
    try {
      fetchLoading(true);
      friendListResponse.value = ApiResponse<UserDataResponse>.loading();
      final studentResults = await studentRepo.getallfriends("BscCSIT-4th Sem");
      if (studentResults.status == ApiStatus.SUCCESS) {
        friendListResponse.value =
            ApiResponse<UserDataResponse>.completed(studentResults.response);
      }
    } catch (e) {
      fetchLoading(false);

      log('Error while getting data: $e');
    } finally {
      fetchLoading(false);
    }
  }

  var isFetchLoading = false.obs;

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

  //-------------ADD BALANCE TO STUDETN ID
  var balanceLoaidng = false.obs;
  Future<void> loadBalance(
    String userId,
    int oldbalance,
    int newbalance,
  ) async {
    try {
      balanceLoaidng(true);

      // Perform further operations with finalScore as needed
      final filters = {
        'userid': userId,
      };

      final newUpdate = {
        "studentScore": oldbalance + newbalance,
      };

      final response = await userDataRepository.doUpdate(
          filters, newUpdate, ApiEndpoints.studentCollection);
      if (response.status == ApiStatus.SUCCESS) {
        balanceLoaidng(false);

        fetchUserData(userId);
        fetchStudents();
      } else {
        balanceLoaidng(false);
        log("Failed to add friend: ${response.message}");
      }
    } catch (e) {
      balanceLoaidng(false);
      log('Error while adding friend: $e');
    }
  }

//----------fetch the studetn balance .
  var fetchingBalance = false.obs;
  final GreatRepository greatrepo = GreatRepository();
  final Rx<ApiResponse<StudentBalanceResponse>> getBalanceResponse =
      ApiResponse<StudentBalanceResponse>.initial().obs;
  var isblance = false.obs;
  Future<void> fetchBalance(String userid) async {
    try {
      log("this iteh fetch blaance -------");
      fetchingBalance(true);

      final filter = {
        'studentId': userid,

        // Add more filters as needed
      };

      getBalanceResponse.value = ApiResponse<StudentBalanceResponse>.loading();
      final allbalanceResult = await greatrepo.getFromDatabase(filter,
          StudentBalanceResponse.fromJson, ApiEndpoints.balanceCollection);
      if (allbalanceResult.status == ApiStatus.SUCCESS) {
        getBalanceResponse.value =
            ApiResponse<StudentBalanceResponse>.completed(
                allbalanceResult.response);
        if (getBalanceResponse.value.response!.length != 0) {
          isblance(true);
        }

        fetchingBalance(false);
      }
    } catch (e) {
      log('Error while getting data: $e');
    }
  }
}
