// To parse this JSON data, do
//
//     final CategoryListResponse = CategoryListResponseFromJson(jsonString);

import 'dart:convert';

CategoryListResponse categoryListResponseFromJson(String str) =>
    CategoryListResponse.fromJson(json.decode(str));

String categoryListResponseToJson(CategoryListResponse data) =>
    json.encode(data.toJson());

class CategoryListResponse {
  String? message;
  List<Category>? categories;

  CategoryListResponse({
    this.message,
    this.categories,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      CategoryListResponse(
        message: json["message"],
        categories: json["Categories"] == null
            ? []
            : List<Category>.from(
                json["Categories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "Categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  int? categoryId;
  String? title;

  Category({
    this.categoryId,
    this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "title": title,
      };
}
