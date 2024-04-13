import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GroupMemberDeleteRepository {
  Future<SingleApiResponse<void>> deleteGroupMember(
    String studentid,
  ) async {
    final response = await ApiClient().update<void>(
      filters: {'userid': studentid},
      updateField: {'groupid': ''},
      collection: ApiEndpoints.studentCollection,
      responseType: (snapshot) =>
          null, // Since responseType is not used for update operation
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
