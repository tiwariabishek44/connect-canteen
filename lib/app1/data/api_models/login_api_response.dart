// To parse this JSON data, do
//
//     final LoginResponse = LoginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String? token;
  String? message;
  int? userId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? role;
  String? formattedTokenExpiryDate;

  LoginResponse({
    this.token,
    this.message,
    this.userId,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.role,
    this.formattedTokenExpiryDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        message: json["message"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        role: json["role"],
        formattedTokenExpiryDate: json["formattedTokenExpiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "message": message,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "email": email,
        "role": role,
        "formattedTokenExpiryDate": formattedTokenExpiryDate,
      };
}
