import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/service/api_cilent.dart';

class AddOrderRepository {
  Future<ApiResponse<OrderResponse>> addOrder(
    requesBody,
  ) async {
    final response = await ApiClient().postFirebaseData<OrderResponse>(
      collection: ApiEndpoints.productionOrderCollection,
      requestBody: requesBody,
      responseType: (json) => OrderResponse.fromJson(json),
    );

    return response;
  }
}
