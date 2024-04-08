import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';

import 'package:connect_canteen/app/service/api_client.dart';

class ProductUpdateRepository {
  Future<SingleApiResponse<void>> productStateUpdate(
      String productId, bool state) async {
    final response = await ApiClient().update<void>(
      filters: {
        'name': productId,
      },
      updateField: {'active': state},
      collection: ApiEndpoints.productCollection,
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

//price update

  Future<SingleApiResponse<void>> priceUPdate(
      String productId, double price) async {
    final response = await ApiClient().update<void>(
      filters: {
        'name': productId,
      },
      updateField: {'price': price},
      collection: ApiEndpoints.productCollection,
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
