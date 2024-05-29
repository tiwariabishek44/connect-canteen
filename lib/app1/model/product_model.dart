class Products {
  final String imageUrl;
  final String name;
  final double price;

  const Products({
    required this.imageUrl,
    required this.name,
    required this.price,
  });
}
class ProductResponseModel {
  final String productId; // Unique identifier for the product
  final String name;
  final String image;
  final double price;
  final bool active; // Added field
  final String referenceSchool; // Added field

  ProductResponseModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.active, // Added parameter
    required this.referenceSchool, // Added parameter
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      productId: json['productId'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      price: json['price']?.toDouble() ?? 0.0,
      active: json['active'] ?? false, // Added field mapping
      referenceSchool: json['referenceSchool'] ?? "", // Added field mapping
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'active': active, // Added field mapping
      'referenceSchool': referenceSchool, // Added field mapping
    };
  }
}
