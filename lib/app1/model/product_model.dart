class ProductResponseModel {
  final String productId; // Unique identifier for the product
  final String name;
  final String proudctImage;
  final double price;
  final bool active; // Added field
  final String referenceSchool; // Added field
  final String type; // New field
  final String category;

  ProductResponseModel({
    required this.productId,
    required this.name,
    required this.proudctImage,
    required this.price,
    required this.active, // Added parameter
    required this.referenceSchool, // Added parameter
    required this.type, // New parameter
    required this.category,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      productId: json['productId'] ?? "",
      name: json['name'] ?? "",
      proudctImage: json['image'] ?? "",
      price: json['price']?.toDouble() ?? 0.0,
      active: json['active'] ?? false, // Added field mapping
      referenceSchool: json['referenceSchool'] ?? "", // Added field mapping
      type: json['type'] ?? "", // New field mapping
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': proudctImage,
      'price': price,
      'active': active, // Added field mapping
      'referenceSchool': referenceSchool, // Added field mapping
      'type': type, // New field mapping
      'category': category,
    };
  }
}
