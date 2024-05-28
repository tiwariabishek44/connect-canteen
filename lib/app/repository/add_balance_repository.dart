import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/models/student_balance_model.dart';
import 'package:connect_canteen/app/models/student_fine_Response.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class AddBalanceRepository {
  Future<ApiResponse<StudentBalanceResponse>> addBalance(
    requesBody,
  ) async {
    final response = await ApiClient().postFirebaseData<StudentBalanceResponse>(
      collection: ApiEndpoints.balanceCollection,
      requestBody: requesBody,
      responseType: (json) => StudentBalanceResponse.fromJson(json),
    );

    return response;
  }
}
