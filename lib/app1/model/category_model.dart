class CategoryModel {
  final String school;
  final String name;
  final String image;

  CategoryModel({
    required this.school,
    required this.name,
    required this.image,
  });

  // Convert a CategoryModel object into a map
  Map<String, dynamic> toMap() {
    return {
      'school': school,
      'name': name,
      'image': image,
    };
  }

  // Create a CategoryModel object from a map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      school: map['school'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
