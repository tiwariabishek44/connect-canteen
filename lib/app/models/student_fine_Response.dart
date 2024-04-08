class StudentFineResponse {
  final String studentId;

  final int fineAmount;
  final String date;

  StudentFineResponse({
    required this.studentId,
    required this.fineAmount,
    required this.date,
  });

  factory StudentFineResponse.fromJson(Map<String, dynamic> json) {
    return StudentFineResponse(
      studentId: json['studentId'] ?? '',

      fineAmount: json['fineAmount'] ?? 0,
      date: json['date'] ?? '', // Assuming date is provided as a string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'fineAmount': fineAmount,
      'date': date,
    };
  }
}
