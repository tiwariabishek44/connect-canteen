import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/product_model.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class AllProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Product>> getallproducts(bool activeState) async {
    final Map<String, dynamic>? filters = activeState ? {'active': true} : null;

    final response = await _apiClient.getFirebaseData<Product>(
      filters: filters,
      collection: ApiEndpoints.productCollection,
      responseType: (json) => Product.fromJson(json),
    );

    return response;
  }
}
