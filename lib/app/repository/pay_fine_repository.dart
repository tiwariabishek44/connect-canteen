import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/models/student_fine_Response.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class PayFineRepository {
  Future<ApiResponse<StudentFineResponse>> payFine(
    requesBody,
  ) async {
    final response = await ApiClient().postFirebaseData<StudentFineResponse>(
      collection: ApiEndpoints.fineCollection,
      requestBody: requesBody,
      responseType: (json) => StudentFineResponse.fromJson(json),
    );

    return response;
  }

  Future<ApiResponse<StudentFineResponse>> getFines(String studentId) async {
    final response = await ApiClient().getFirebaseData<StudentFineResponse>(
      collection: ApiEndpoints.fineCollection,
      filters: {
        "studentId": studentId,
        // Add more filters as needed
      },
      responseType: (json) => StudentFineResponse.fromJson(json),
    );

    return response;
  }
}
