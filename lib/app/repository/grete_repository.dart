import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GreatRepository {
//--------to do update in database --------
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

//-------------to get the from database------------

  Future<ApiResponse<T>> getFromDatabase<T>(
      filter, T Function(Map<String, dynamic>) fromJson, collection) async {
    log(" ------------we are gettiing form Great Repository");
    final response = await ApiClient().getFirebaseData<T>(
      collection: collection,
      filters: filter,
      responseType: fromJson,
    );

    return response;
  }

  //--------------to do post in database ---------

  Future<ApiResponse<T>> doPostInDatabase<T>(requestBody,
      T Function(Map<String, dynamic>) fromJson, collection) async {
    final response = await ApiClient().postFirebaseData<T>(
      collection: collection,
      requestBody: requestBody,
      responseType: (json) =>
          fromJson(json as Map<String, dynamic>), // Adjust here
    );

    return response;
  }
}
