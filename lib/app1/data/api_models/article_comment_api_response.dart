// To parse this JSON data, do
//
//     final ArticleCommentApiResponse = ArticleCommentApiResponseFromJson(jsonString);

import 'dart:convert';

ArticleCommentApiResponse articleCommentApiResponseFromJson(String str) =>
    ArticleCommentApiResponse.fromJson(json.decode(str));

String articleCommentApiResponseToJson(ArticleCommentApiResponse data) =>
    json.encode(data.toJson());

class ArticleCommentApiResponse {
  Comment? comment;
  String? status;
  String? message;

  ArticleCommentApiResponse({
    this.comment,
    this.status,
    this.message,
  });

  factory ArticleCommentApiResponse.fromJson(Map<String, dynamic> json) =>
      ArticleCommentApiResponse(
        comment:
            json["Comment"] == null ? null : Comment.fromJson(json["Comment"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "Comment": comment?.toJson(),
        "status": status,
        "message": message,
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
