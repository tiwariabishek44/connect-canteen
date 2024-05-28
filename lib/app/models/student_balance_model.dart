class StudentBalanceResponse {
  final String studentId;

  final int loadBalance;
  final String date;

  StudentBalanceResponse({
    required this.studentId,
    required this.loadBalance,
    required this.date,
  });

  factory StudentBalanceResponse.fromJson(Map<String, dynamic> json) {
    return StudentBalanceResponse(
      studentId: json['studentId'] ?? '',

      loadBalance: json['fineAmount'] ?? 0,
      date: json['date'] ?? '', // Assuming date is provided as a string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'fineAmount': loadBalance,
      'date': date,
    };
  }
}
