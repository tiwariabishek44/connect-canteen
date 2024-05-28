// To parse this JSON data, do
//
//     final AdvertisementResponse = AdvertisementResponseFromJson(jsonString);

import 'dart:convert';

AdvertisementResponse advertisementResponseFromJson(String str) =>
    AdvertisementResponse.fromJson(json.decode(str));

String advertisementResponseToJson(AdvertisementResponse data) =>
    json.encode(data.toJson());

class AdvertisementResponse {
  String? applicationAd1;

  AdvertisementResponse({
    this.applicationAd1,
  });

  factory AdvertisementResponse.fromJson(Map<String, dynamic> json) =>
      AdvertisementResponse(
        applicationAd1: json["applicationAd1"],
      );

  Map<String, dynamic> toJson() => {
        "applicationAd1": applicationAd1,
      };
}
