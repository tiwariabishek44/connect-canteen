class StudentDataResponse {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String groupid;
  final String classes;
  final String profilePicture;
  final int studentScore;
  final int fineAmount;
  final int miCoin;
  final String schoolId;
  final String schoolName; // Added school name field

  StudentDataResponse({
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.groupid,
    required this.classes,
    required this.profilePicture,
    required this.studentScore,
    required this.fineAmount,
    required this.miCoin,
    required this.schoolId,
    required this.schoolName, // Included in the constructor
  });

  factory StudentDataResponse.fromJson(Map<String, dynamic> json) {
    return StudentDataResponse(
      userid: json['userid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      groupid: json['groupid'] ?? '',
      classes: json['classes'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      studentScore: json['studentScore'] ?? 0,
      fineAmount: json['fineAmount'] ?? 0,
      miCoin: json['miCoin'] ?? 0,
      schoolId: json['schoolId'] ?? '',
      schoolName: json['schoolName'] ?? '', // Parsing school name
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'phone': phone,
      'groupid': groupid,
      'classes': classes,
      'profilePicture': profilePicture,
      'studentScore': studentScore,
      'fineAmount': fineAmount,
      'miCoin': miCoin,
      'schoolId': schoolId,
      'schoolName': schoolName, // Adding school name to the map
    };
  }
}
