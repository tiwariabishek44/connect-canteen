class StudentDataResponse {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String classes;
  final String profilePicture;
  final String schoolId;
  final String schoolName;
  final int creditScore; // Existing creditScore field
  final double depositAmount; // New depositAmount field
  final double cashbackAmount; // New cashbackAmount field

  StudentDataResponse({
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.classes,
    required this.profilePicture,
    required this.schoolId,
    required this.schoolName,
    required this.creditScore,
    required this.depositAmount, // Included in the constructor
    required this.cashbackAmount, // Included in the constructor
  });

  factory StudentDataResponse.fromJson(Map<String, dynamic> json) {
    return StudentDataResponse(
      userid: json['userid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      classes: json['classes'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      schoolId: json['schoolId'] ?? '',
      schoolName: json['schoolName'] ?? '',
      creditScore: json['creditScore'] ?? 0,
      depositAmount:
          json['depositAmount']?.toDouble() ?? 0.0, // Parsing depositAmount
      cashbackAmount:
          json['cashbackAmount']?.toDouble() ?? 0.0, // Parsing cashbackAmount
    );
  }

  get id => null;

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'phone': phone,
      'classes': classes,
      'profilePicture': profilePicture,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'creditScore': creditScore,
      'depositAmount': depositAmount, // Adding depositAmount to the map

      'cashbackAmount': cashbackAmount, // Adding cashbackAmount to the map
    };
  }
}
