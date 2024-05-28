// To parse this JSON data, do
//
//     final ChangePasswordApiResponse = ChangePasswordApiResponseFromJson(jsonString);

import 'dart:convert';

ChangePasswordApiResponse changePasswordApiResponseFromJson(String str) =>
    ChangePasswordApiResponse.fromJson(json.decode(str));

String changePasswordApiResponseToJson(ChangePasswordApiResponse data) =>
    json.encode(data.toJson());

class ChangePasswordApiResponse {
  String? message;
  bool? success;

  ChangePasswordApiResponse({
    this.message,
    this.success,
  });

  factory ChangePasswordApiResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasswordApiResponse(
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}
