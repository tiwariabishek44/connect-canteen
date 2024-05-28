import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../cons/api_end_points.dart';

class ApiClient {
  Future<ApiResponse<T>> postApi<T>(
    String endPoint, {
    Map<String, dynamic>? requestBody,
    bool? isMultiPartRequest,
    T Function(dynamic json)? responseType,
    String? accessToken,
  }) async {
    Map<String, String> header;

    isMultiPartRequest!
        ? header = {
            "Content-Type": "multipart/form-data",
          }
        : header = accessToken == null
            ? {
                'Content-Type': 'application/json',
              }
            : {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              };

    log("header:$header");

    try {
      // log("-----Incomming Body: $endPoint ${requestBody.toString()}");

      if (isMultiPartRequest) {
        var request = http.MultipartRequest('POST', Uri.parse(endPoint));

        request.headers.addAll(header);
        requestBody?.forEach((key, value) {
          // Check if the value is a string, and add it without jsonEncode
          if (value is String) {
            request.fields[key] = value;
            log("$key $value");
          } else {
            // For non-string values, use jsonEncode
            request.fields[key] = jsonEncode(value);
            log("$key " + value);
          }
        });
        var response = await request.send();
        log('Response Status:: ${response.statusCode}');
        final json = await response.stream.bytesToString();
        if (response.statusCode == 200 || response.statusCode == 201) {
          final jsonData = jsonDecode(json);
          final data =
              responseType != null ? responseType(jsonData) : json as T;
          return ApiResponse.completed(data);
        } else {
          log("error");
          return ApiResponse.error(jsonDecode(json)["error"]);
        }
      } else {
        log("api client: $requestBody");
        final response = requestBody == null
            ? await http.post(
                Uri.parse(endPoint),
                headers: header,
              )
            : await http.post(
                Uri.parse(endPoint),
                headers: header,
                body: json.encode(requestBody),
              );
        log("-------SERVER RESPONSE: $endPoint ${response.body.toString()}");

        final jsonData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data =
              responseType != null ? responseType(jsonData) : json as T;
          return ApiResponse.completed(data);
        } else {
          print('response status::::: ${response.statusCode}');
          final message = ApiMessage().getMessage(response.statusCode);
          if (endPoint == 'oauth/token' && response.statusCode == 400) {
            return ApiResponse.error(message);
          }
          if (response.statusCode == 401 || response.statusCode == 404) {
            return ApiResponse.error(jsonData['error']);
          }
          if (response.statusCode == 406 ||
              response.statusCode == 400 ||
              response.statusCode == 203 ||
              response.statusCode == 500) {
            return ApiResponse.error(jsonData['message']);
          }

          return ApiResponse.error(message);
        }
      }
    } on SocketException {
      return ApiResponse.error("No internet connection");
    } catch (e) {
      log("Api Client:Error Parsing Data: $e for $endPoint");
      return ApiResponse.error("Error Parsing Data");
    }
  }

  Future<ApiResponse<T>> getApi<T>(
    String endPoint, {
    int? params,
    T Function(dynamic json)? responseType,
  }) async {
    // var header = {
    //   "Content-Type": "application/json",
    //   "Accept": "application/json",
    // };

    try {
      final uri = Uri.parse(endPoint + (params != null ? '$params' : ''));

      final response = await http.get(uri);
      debugPrint(response.statusCode.toString());
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = responseType != null ? responseType(jsonData) : json as T;
        return ApiResponse.completed(data);
      } else {
        log("error");
        var message = jsonData["message"];
        return ApiResponse.error(message);
      }
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse.error("Something went wrong. Please try again later");
    }
  }

//---------------login api call-----------//
}

class ApiResponse<T> {
  ApiStatus status;
  T? response;
  String? message;

  ApiResponse.initial([this.message])
      : status = ApiStatus.INITIAL,
        response = null;

  ApiResponse.loading([this.message])
      : status = ApiStatus.LOADING,
        response = null;
  ApiResponse.completed(this.response)
      : status = ApiStatus.SUCCESS,
        message = null;
  ApiResponse.error([this.message])
      : status = ApiStatus.ERROR,
        response = null;

  @override
  String toString() {
    return "Status : $status \nData : $response \nMessage : $message";
  }
}

class ApiMessage {
  String getMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid Credentails';
      case 401:
        return 'Unauthorised';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 500:
        return 'Bad Request';
      case 502:
        return 'Server Error';
      default:
        return 'Error getting data. Error Code: $statusCode';
    }
  }
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }
