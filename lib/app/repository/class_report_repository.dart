import 'dart:developer';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class ClassReportRepository {
  Future<ApiResponse<OrderResponse>> getClassReport(
      String mealtime, String date) async {
    log("thi is the meal time ===========$mealtime  $date");
    final response = await ApiClient().getFirebaseData<OrderResponse>(
      collection: ApiEndpoints.orderCollection,
      filters: mealtime == 'All'
          ? {
              "date": date,
              'orderType': 'regular',

              // Add more filters as needed
            }
          : {
              "date": date,
              "mealtime": mealtime,
              'orderType': 'regular',

              // Add more filters as needed
            },
      responseType: (json) => OrderResponse.fromJson(json),
    );

    return response;
  }
}

class ClassReportRepositorys {
  Future<ApiResponse<OrderResponse>> getRemaningOrders(
      String mealtime, String date) async {
    log("fetching the remaning orders ===========$mealtime  $date");
    final response = await ApiClient().getFirebaseData<OrderResponse>(
      collection: ApiEndpoints.orderCollection,
      filters: mealtime == 'All'
          ? {
              "date": date,
              'orderType': 'regular',
              "checkout": "false",

              // Add more filters as needed
            }
          : {
              "date": date,
              "mealtime": mealtime,
              'orderType': 'regular',
              "checkout": "false",

              // Add more filters as needed
            },
      responseType: (json) => OrderResponse.fromJson(json),
    );

    return response;
  }
}
