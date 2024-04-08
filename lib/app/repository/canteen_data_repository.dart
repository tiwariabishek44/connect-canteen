import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/canteen_model.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class CanteenDataRepository {
  Future<ApiResponse<CanteenDataResponse>> getCanteenData(
      Map<String, dynamic> filters) async {
    final response = await ApiClient().getFirebaseData<CanteenDataResponse>(
      collection: ApiEndpoints.canteenCollection,
      filters: filters,
      responseType: (json) => CanteenDataResponse.fromJson(json),
    );

    return response;
  }
}
