class SchoolModel {
  final String schoolId;
  String name;
  String address;
  List<ClassModel> classes;

  SchoolModel({
    required this.schoolId,
    required this.name,
    required this.address,
    required this.classes,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    var classList = json['classes'] as List;
    List<ClassModel> classes =
        classList.map((className) => ClassModel(name: className)).toList();

    return SchoolModel(
      schoolId: json['schoolId'],
      name: json['name'],
      address: json['address'],
      classes: classes,
    );
  }

  Map<String, dynamic> toJson() {
    List<String> classNames = classes.map((cls) => cls.name).toList();

    return {
      'schoolId': schoolId,
      'name': name,
      'address': address,
      'classes': classNames,
    };
  }
}

class ClassModel {
  String name;

  ClassModel({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
