import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/service/api_cilent.dart';

class AddProductRepository {
  Future<ApiResponse<ProductResponseModel>> addBalance(
    requesBody,
  ) async {
    final response = await ApiClient().postFirebaseData<ProductResponseModel>(
      collection: ApiEndpoints.productionProdcutCollection,
      requestBody: requesBody,
      responseType: (json) => ProductResponseModel.fromJson(json),
    );

    return response;
  }
}
