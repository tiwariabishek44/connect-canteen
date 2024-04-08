import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GetGroupOrederByCanteenRepository {
  Future<ApiResponse<OrderResponse>> getOrders(String groupId) async {
    final response = await ApiClient().getFirebaseData<OrderResponse>(
      collection: ApiEndpoints.orderCollection,
      filters: {
        "groupid": groupId,
        'checkout': 'false',
        // Add more filters as needed
      },
      responseType: (json) => OrderResponse.fromJson(json),
    );

    return response;
  }
}
