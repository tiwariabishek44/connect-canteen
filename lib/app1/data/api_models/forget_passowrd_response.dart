// To parse this JSON data, do
//
//     final ForgetPasswordResponse = ForgetPasswordResponseFromJson(jsonString);

import 'dart:convert';

ForgetPasswordResponse forgetPasswordResponseFromJson(String str) =>
    ForgetPasswordResponse.fromJson(json.decode(str));

String forgetPasswordResponseToJson(ForgetPasswordResponse data) =>
    json.encode(data.toJson());

class ForgetPasswordResponse {
  String? message;
  bool? success;

  ForgetPasswordResponse({
    this.message,
    this.success,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgetPasswordResponse(
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}
