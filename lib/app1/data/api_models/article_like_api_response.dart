// To parse this JSON data, do
//
//     final ArticleLikeApiResponse = ArticleLikeApiResponseFromJson(jsonString);

import 'dart:convert';

ArticleLikeApiResponse articleLikeApiResponseFromJson(String str) =>
    ArticleLikeApiResponse.fromJson(json.decode(str));

String articleLikeApiResponseToJson(ArticleLikeApiResponse data) =>
    json.encode(data.toJson());

class ArticleLikeApiResponse {
  String? message;
  String? status;

  ArticleLikeApiResponse({
    this.message,
    this.status,
  });

  factory ArticleLikeApiResponse.fromJson(Map<String, dynamic> json) =>
      ArticleLikeApiResponse(
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
      };
}
