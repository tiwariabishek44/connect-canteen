class MealTime {
  final String schoolReference;
  final String mealTime;

  MealTime({
    required this.schoolReference,
    required this.mealTime,
  });

  factory MealTime.fromJson(Map<String, dynamic> json) {
    return MealTime(
      schoolReference: json['schoolReference'],
      mealTime: json['mealTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolReference': schoolReference,
      'mealTime': mealTime,
    };
  }
}
