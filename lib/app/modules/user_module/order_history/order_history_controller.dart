import 'dart:developer';
import 'package:get/get.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/order_history_respository.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class HistoryController extends GetxController {
  final loginController = Get.put(LoginController());
  var isLoading = false.obs;
  var isdata = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroupHistoryOrders();

    log("----History order is  IS INITILIZE");
  }

  final orderHistoryRepository = OrderHistoryRepository();

  final Rx<ApiResponse<OrderResponse>> orderHistoryResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchGroupHistoryOrders() async {
    try {
      isLoading(true);
      isdata(false);
      orderHistoryResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderHistoryRepository.getGroupHistory(
          loginController.userDataResponse.value.response!.first.groupid);
      if (orderResult.status == ApiStatus.SUCCESS) {
        orderHistoryResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        if (orderHistoryResponse.value.response!.length > 0) {
          isdata(true);
        }
      }
    } catch (e) {
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }
}
