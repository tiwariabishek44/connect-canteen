// To parse this JSON data, do
//
//     final ArticleResponse = ArticleResponseFromJson(jsonString);

import 'dart:convert';

ArticleResponse articleResponseFromJson(String str) =>
    ArticleResponse.fromJson(json.decode(str));

String articleResponseToJson(ArticleResponse data) =>
    json.encode(data.toJson());

class ArticleResponse {
  int? totalItems;
  String? firstPage;
  String? lastPage;
  String? nextPage;
  int? totalPages;
  int? currentPage;
  List<Article>? articles;
  String? status;

  ArticleResponse({
    this.totalItems,
    this.firstPage,
    this.lastPage,
    this.nextPage,
    this.totalPages,
    this.currentPage,
    this.articles,
    this.status,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      ArticleResponse(
        totalItems: json["totalItems"],
        firstPage: json["firstPage"],
        lastPage: json["lastPage"],
        nextPage: json["nextPage"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        articles: json["articles"] == null
            ? []
            : List<Article>.from(
                json["articles"]!.map((x) => Article.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "firstPage": firstPage,
        "lastPage": lastPage,
        "nextPage": nextPage,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "articles": articles == null
            ? []
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
        "status": status,
      };
}

class Article {
  int? id;
  String? title;
  List<String>? imageUrls;
  String? createdDate;
  String? subDetails;
  String? categoryTitle;
  String? postedBy;
  int? likeAmount;
  List<dynamic>? likedUserIds;
  int? commentCount;

  Article({
    this.id,
    this.title,
    this.imageUrls,
    this.createdDate,
    this.subDetails,
    this.categoryTitle,
    this.postedBy,
    this.likeAmount,
    this.likedUserIds,
    this.commentCount,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        imageUrls: json["imageUrls"] == null
            ? []
            : List<String>.from(json["imageUrls"]!.map((x) => x)),
        createdDate: json["createdDate"],
        subDetails: json["subDetails"],
        categoryTitle: json["categoryTitle"],
        postedBy: json["postedBy"],
        likeAmount: json["likeAmount"],
        likedUserIds: json["likedUserIds"] == null
            ? []
            : List<dynamic>.from(json["likedUserIds"]!.map((x) => x)),
        commentCount: json["commentCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "imageUrls": imageUrls == null
            ? []
            : List<dynamic>.from(imageUrls!.map((x) => x)),
        "createdDate": createdDate,
        "subDetails": subDetails,
        "categoryTitle": categoryTitle,
        "postedBy": postedBy,
        "likeAmount": likeAmount,
        "likedUserIds": likedUserIds == null
            ? []
            : List<dynamic>.from(likedUserIds!.map((x) => x)),
        "commentCount": commentCount,
      };
}

enum CategoryTitle { BUSINESS, SPORTS }

final categoryTitleValues = EnumValues(
    {"Business": CategoryTitle.BUSINESS, "Sports": CategoryTitle.SPORTS});

enum CreatedDate { THE_202402081001, THE_202402081002 }

final createdDateValues = EnumValues({
  "2024-02-08 10:01": CreatedDate.THE_202402081001,
  "2024-02-08 10:02": CreatedDate.THE_202402081002
});

enum PostedBy { REPORTER }

final postedByValues = EnumValues({"Reporter": PostedBy.REPORTER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
