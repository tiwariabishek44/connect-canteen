import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class UserDataRepository {
  Future<ApiResponse<UserDataResponse>> getUserData(
      Map<String, dynamic> filters) async {
    final response = await ApiClient().getFirebaseData<UserDataResponse>(
      collection: ApiEndpoints.studentCollection,
      filters: filters,
      responseType: (json) => UserDataResponse.fromJson(json),
    );

    return response;
  }

  Future<SingleApiResponse<void>> userDataUpdate(String userid, update) async {
    final response = await ApiClient().update<void>(
      filters: {
        'userid': userid,
      },
      updateField: update,
      collection: ApiEndpoints.studentCollection,
      responseType:
          (snapshot) {}, // Since responseType is not used for update operation
    );

    // Check if update was successful
    if (response.status == ApiStatus.SUCCESS) {
      // Update successful
      return SingleApiResponse.completed("Update successful");
    } else {
      // Update failed, return the response
      return response;
    }
  }
}
