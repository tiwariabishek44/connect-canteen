import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/group_api_response.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GetGroupRepository {
  Future<ApiResponse<GroupApiResponse>> getGroupData(String groupid) async {
    final response = await ApiClient().getFirebaseData<GroupApiResponse>(
      collection: ApiEndpoints.groupCollection,
      filters: {
        "groupId": groupid,
        // Add more filters as needed
      },
      responseType: (json) => GroupApiResponse.fromJson(json),
    );

    return response;
  }
}
