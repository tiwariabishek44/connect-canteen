// To parse this JSON data, do
//
//     final RegisterResponse = RegisterResponseFromJson(jsonString);

class RegisterResponse {
  Details? details;
  String? status;
  String? message;

  RegisterResponse({
    this.details,
    this.status,
    this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "details": details?.toJson(),
        "status": status,
        "message": message,
      };
}

class Details {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? password;
  String? createdDate;
  dynamic picture;

  Details({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.password,
    this.createdDate,
    this.picture,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        password: json["password"],
        createdDate: json["createdDate"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "mobileNumber": mobileNumber,
        "password": password,
        "createdDate": createdDate,
        "picture": picture,
      };
}
