class AdminSummary {
  final String adminId;
  final String schoolId;
  final String date;
  final double totalLoadAmount;
  final String studentId;
  final String studentName;
  final String studentClass;

  AdminSummary({
    required this.adminId,
    required this.schoolId,
    required this.date,
    required this.totalLoadAmount,
    required this.studentId,
    required this.studentName,
    required this.studentClass,
  });

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'schoolId': schoolId,
      'date': date,
      'totalLoadAmount': totalLoadAmount,
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
    };
  }

  factory AdminSummary.fromJson(Map<String, dynamic> json) {
    return AdminSummary(
      adminId: json['adminId'],
      schoolId: json['schoolId'],
      date: json['date'],
      totalLoadAmount: json['totalLoadAmount'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      studentClass: json['studentClass'],
    );
  }
}
