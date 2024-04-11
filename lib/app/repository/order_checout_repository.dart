import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GreatRepository {
  Future<SingleApiResponse<void>> doUpdate(
      filter, updateField, collection) async {
    final response = await ApiClient().update<void>(
      filters: filter,
      updateField: updateField,
      collection: collection,
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

//-------------to get the orders------------

  Future<ApiResponse<T>> doGetFromDatabase<T>(
    filter,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await ApiClient().getFirebaseData<T>(
      collection: ApiEndpoints.orderCollection,
      filters: filter,
      responseType: fromJson,
    );

    return response;
  }
}
