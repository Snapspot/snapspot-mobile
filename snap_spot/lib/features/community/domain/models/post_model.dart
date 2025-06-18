import 'comment_model.dart';

class Post {
  final int id;
  final String userName;
  final String userAvatarUrl;
  final String location;
  final DateTime timestamp;
  final String content;
  final List<String> imageUrls;
  final int likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.location,
    required this.timestamp,
    required this.content,
    required this.imageUrls,
    required this.likes,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userName: json['userName'],
      userAvatarUrl: json['userAvatarUrl'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls']),
      likes: json['likes'],
      comments: json['commentList'] != null
          ? List<Comment>.from(
        json['commentList'].map((c) => Comment.fromJson(c)),
      )
          : [],
    );
  }
}
