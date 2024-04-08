import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/product_model.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GetFriendRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<UserDataResponse>> getallfriends(String classes) async {
    final response = await _apiClient.getFirebaseData<UserDataResponse>(
      collection: ApiEndpoints.studentCollection,
      filters: {
        "classes": classes,
        // Add more filters as needed
      },
      responseType: (json) => UserDataResponse.fromJson(json),
    );

    return response;
  }
}
