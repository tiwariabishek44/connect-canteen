// To parse this JSON data, do
//
//     final ArticleByCategoryResponse = ArticleByCategoryResponseFromJson(jsonString);

import 'dart:convert';

ArticleByCategoryResponse articleByCategoryResponseFromJson(String str) =>
    ArticleByCategoryResponse.fromJson(json.decode(str));

String articleByCategoryResponseToJson(ArticleByCategoryResponse data) =>
    json.encode(data.toJson());

class ArticleByCategoryResponse {
  int? totalItems;
  String? firstPage;
  String? lastPage;
  List<Article>? articles;
  String? nextPage;
  int? totalPages;
  int? currentPage;
  String? status;

  ArticleByCategoryResponse({
    this.totalItems,
    this.firstPage,
    this.lastPage,
    this.articles,
    this.nextPage,
    this.totalPages,
    this.currentPage,
    this.status,
  });

  factory ArticleByCategoryResponse.fromJson(Map<String, dynamic> json) =>
      ArticleByCategoryResponse(
        totalItems: json["totalItems"],
        firstPage: json["firstPage"],
        lastPage: json["lastPage"],
        articles: json["Articles"] == null
            ? []
            : List<Article>.from(
                json["Articles"]!.map((x) => Article.fromJson(x))),
        nextPage: json["nextPage"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "firstPage": firstPage,
        "lastPage": lastPage,
        "Articles": articles == null
            ? []
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
        "nextPage": nextPage,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "status": status,
      };
}

class Article {
  int? id;
  String? title;
  String? subDetails;
  List<String>? imageUrls;
  String? createdDate;
  String? categoryTitle;
  String? postedBy;
  int? likeAmount;
  List<dynamic>? likedUserIds;
  int? commentCount;

  Article({
    this.id,
    this.title,
    this.subDetails,
    this.imageUrls,
    this.createdDate,
    this.categoryTitle,
    this.postedBy,
    this.likeAmount,
    this.likedUserIds,
    this.commentCount,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        subDetails: json["subDetails"],
        imageUrls: json["imageUrls"] == null
            ? []
            : List<String>.from(json["imageUrls"]!.map((x) => x)),
        createdDate: json["createdDate"]!,
        categoryTitle: json["categoryTitle"]!,
        postedBy: json["postedBy"]!,
        likeAmount: json["likeAmount"],
        likedUserIds: json["likedUserIds"] == null
            ? []
            : List<dynamic>.from(json["likedUserIds"]!.map((x) => x)),
        commentCount: json["commentCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subDetails": subDetails,
        "imageUrls": imageUrls == null
            ? []
            : List<dynamic>.from(imageUrls!.map((x) => x)),
        "createdDate": createdDate,
        "categoryTitle": categoryTitle,
        "postedBy": postedBy,
        "likeAmount": likeAmount,
        "likedUserIds": likedUserIds == null
            ? []
            : List<dynamic>.from(likedUserIds!.map((x) => x)),
        "commentCount": commentCount,
      };
}





// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
