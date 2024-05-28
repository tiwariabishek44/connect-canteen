// To parse this JSON data, do
//
//     final ArticleDetailApiResponse = ArticleDetailApiResponseFromJson(jsonString);

import 'dart:convert';

ArticleDetailApiResponse articleDetailApiResponseFromJson(String str) =>
    ArticleDetailApiResponse.fromJson(json.decode(str));

String articleDetailApiResponseToJson(ArticleDetailApiResponse data) =>
    json.encode(data.toJson());

class ArticleDetailApiResponse {
  String? status;
  Article? article;

  ArticleDetailApiResponse({
    this.status,
    this.article,
  });

  factory ArticleDetailApiResponse.fromJson(Map<String, dynamic> json) =>
      ArticleDetailApiResponse(
        status: json["status"],
        article:
            json["Article"] == null ? null : Article.fromJson(json["Article"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Article": article?.toJson(),
      };
}

class Article {
  int? id;
  String? title;
  String? details;
  String? subDetails;
  List<String>? imageUrls;
  String? createdDate;
  String? categoryTitle;
  bool? enabled;
  String? postedBy;
  int? likeAmount;
  List<int>? likedUserIds;
  int? commentCount;
  List<Comment>? comments;

  Article({
    this.id,
    this.title,
    this.details,
    this.subDetails,
    this.imageUrls,
    this.createdDate,
    this.categoryTitle,
    this.enabled,
    this.postedBy,
    this.likeAmount,
    this.likedUserIds,
    this.commentCount,
    this.comments,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        details: json["details"],
        subDetails: json["subDetails"],
        imageUrls: json["imageUrls"] == null
            ? []
            : List<String>.from(json["imageUrls"]!.map((x) => x)),
        createdDate: json["createdDate"],
        categoryTitle: json["categoryTitle"],
        enabled: json["enabled"],
        postedBy: json["postedBy"],
        likeAmount: json["likeAmount"],
        likedUserIds: json["likedUserIds"] == null
            ? []
            : List<int>.from(json["likedUserIds"]!.map((x) => x)),
        commentCount: json["commentCount"],
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "subDetails": subDetails,
        "imageUrls": imageUrls == null
            ? []
            : List<dynamic>.from(imageUrls!.map((x) => x)),
        "createdDate": createdDate,
        "categoryTitle": categoryTitle,
        "enabled": enabled,
        "postedBy": postedBy,
        "likeAmount": likeAmount,
        "likedUserIds": likedUserIds == null
            ? []
            : List<dynamic>.from(likedUserIds!.map((x) => x)),
        "commentCount": commentCount,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
      };
}

class Comment {
  int? commentId;
  String? details;
  String? commentCreatedDate;
  int? articleId;
  String? postedBy;

  Comment({
    this.commentId,
    this.details,
    this.commentCreatedDate,
    this.articleId,
    this.postedBy,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["commentId"],
        details: json["details"],
        commentCreatedDate: json["commentCreatedDate"],
        articleId: json["articleId"],
        postedBy: json["postedBy"],
      );

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "details": details,
        "commentCreatedDate": commentCreatedDate,
        "articleId": articleId,
        "postedBy": postedBy,
      };
}
