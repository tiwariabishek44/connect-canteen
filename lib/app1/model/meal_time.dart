class MealTime {
  final String schoolReference;
  final String mealTime;
  final String finalOrderTime;
  final String restriction; // Updated field

  MealTime({
    required this.schoolReference,
    required this.mealTime,
    required this.finalOrderTime,
    required this.restriction, // Updated constructor
  });

  factory MealTime.fromJson(Map<String, dynamic> json) {
    return MealTime(
      schoolReference: json['schoolReference'],
      mealTime: json['mealTime'],
      finalOrderTime: json['finalOrderTime'],
      restriction: json['restriction'] ?? 'false', // Updated restriction field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolReference': schoolReference,
      'mealTime': mealTime,
      'finalOrderTime': finalOrderTime,
      'restriction': restriction, // Updated restriction field
    };
  }
}
