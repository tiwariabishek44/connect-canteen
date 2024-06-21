class StudentGroupApiResponse {
  String groupId;
  String groupCode;
  String groupName;
  String moderator;

  StudentGroupApiResponse({
    required this.groupId,
    required this.groupCode,
    required this.groupName,
    required this.moderator,
  });

  factory StudentGroupApiResponse.fromJson(Map<String, dynamic> json) {
    return StudentGroupApiResponse(
      groupId: json['groupId'],
      groupCode: json['groupCode'],
      groupName: json['groupName'],
      moderator: json['moderator'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupCode': groupCode,
      'groupName': groupName,
      'moderator': moderator,
    };
  }
}
