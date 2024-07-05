class StudentDataResponse {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String groupid;
  final String groupcod;
  final String classes;
  final String profilePicture;
  final int studentScore;
  final int fineAmount;
  final int miCoin;
  final String schoolId;
  final String schoolName;
  final String groupname;
  final double balance; // Added balance field

  StudentDataResponse({
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.groupid,
    required this.groupcod,
    required this.classes,
    required this.profilePicture,
    required this.studentScore,
    required this.fineAmount,
    required this.miCoin,
    required this.schoolId,
    required this.schoolName,
    required this.groupname,
    required this.balance, // Included in the constructor
  });

  factory StudentDataResponse.fromJson(Map<String, dynamic> json) {
    return StudentDataResponse(
      userid: json['userid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      groupid: json['groupid'] ?? '',
      groupcod: json['groupcod'] ?? '',
      classes: json['classes'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      studentScore: json['studentScore'] ?? 0,
      fineAmount: json['fineAmount'] ?? 0,
      miCoin: json['miCoin'] ?? 0,
      schoolId: json['schoolId'] ?? '',
      schoolName: json['schoolName'] ?? '',
      groupname: json['groupname'] ?? '',
      balance: json['balance'] ?? 0.0, // Parsing balance
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'phone': phone,
      'groupid': groupid,
      'groupcod': groupcod,
      'classes': classes,
      'profilePicture': profilePicture,
      'studentScore': studentScore,
      'fineAmount': fineAmount,
      'miCoin': miCoin,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'groupname': groupname,
      'balance': balance, // Adding balance to the map
    };
  }
}
