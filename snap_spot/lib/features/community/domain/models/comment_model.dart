class Comment {
  final String userName;
  final String userAvatarUrl;
  final String content;
  final DateTime timestamp;
  final int likes;

  Comment({
    required this.userName,
    required this.userAvatarUrl,
    required this.content,
    required this.timestamp,
    required this.likes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userName: json['userName'],
      userAvatarUrl: json['userAvatarUrl'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['likes'],
    );
  }
}
