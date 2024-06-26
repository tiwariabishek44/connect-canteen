import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class FetchGroupMemberRepository {
  Future<ApiResponse<UserDataResponse>> getGroupMember(String groupId) async {
    log("-------fetch the gorup member----------${groupId}");
    final response = await ApiClient().getFirebaseData<UserDataResponse>(
      collection: ApiEndpoints.studentCollection,
      filters: {
        'groupid': groupId,
        // Add more filters as needed
      },
      responseType: (json) => UserDataResponse.fromJson(json),
    );

    log("THIS IS THE NUMBER OF GROUP MEMBER " +
        response.response!.length.toString());

    return response;
  }
}
