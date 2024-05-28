// To parse this JSON data, do
//
//     final LegalAndSupportResponse = LegalAndSupportResponseFromJson(jsonString);

import 'dart:convert';

LegalAndSupportResponse legalAndSupportResponseFromJson(String str) =>
    LegalAndSupportResponse.fromJson(json.decode(str));

String legalAndSupportResponseToJson(LegalAndSupportResponse data) =>
    json.encode(data.toJson());

class LegalAndSupportResponse {
  List<LegalAndSupport>? legalAndSupport;
  String? status;

  LegalAndSupportResponse({
    this.legalAndSupport,
    this.status,
  });

  factory LegalAndSupportResponse.fromJson(Map<String, dynamic> json) =>
      LegalAndSupportResponse(
        legalAndSupport: json["LegalAndSupport"] == null
            ? []
            : List<LegalAndSupport>.from(json["LegalAndSupport"]!
                .map((x) => LegalAndSupport.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "LegalAndSupport": legalAndSupport == null
            ? []
            : List<dynamic>.from(legalAndSupport!.map((x) => x.toJson())),
        "status": status,
      };
}

class LegalAndSupport {
  int? id;
  String? termsAndCondition;
  String? contactUs;
  String? privacyPolicy;

  LegalAndSupport({
    this.id,
    this.termsAndCondition,
    this.contactUs,
    this.privacyPolicy,
  });

  factory LegalAndSupport.fromJson(Map<String, dynamic> json) =>
      LegalAndSupport(
        id: json["id"],
        termsAndCondition: json["termsAndCondition"],
        contactUs: json["contactUs"],
        privacyPolicy: json["privacyPolicy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "termsAndCondition": termsAndCondition,
        "contactUs": contactUs,
        "privacyPolicy": privacyPolicy,
      };
}
