import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/student_fine_Response.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GetFineRepository {
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
