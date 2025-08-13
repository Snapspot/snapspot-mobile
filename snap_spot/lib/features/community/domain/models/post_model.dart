import 'comment_model.dart';

class Post {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final String location;
  final DateTime timestamp;
  final String content;
  final List<String> imageUrls;
  final int likes;
  final int comments;

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

  factory Post.fromApi(Map<String, dynamic> e) {
    int likesValue = (e["likes"] is int)
        ? e["likes"]
        : int.tryParse(e["likes"]?.toString() ?? "0") ?? 0;
    int commentsValue = (e["comments"] is int)
        ? e["comments"]
        : int.tryParse(e["comments"]?.toString() ?? "0") ?? 0;

    return Post(
      id: e["postId"] as String,
      userName: e["user"]?["name"] ?? "",
      userAvatarUrl: e["user"]?["avatar"] ?? "",
      location: e["user"]?["spotname"] ?? "",
      timestamp: DateTime.parse(e["timestamp"] ?? DateTime.now().toIso8601String()),
      content: e["content"] ?? "",
      imageUrls: (e["imageUrl"] is List) ? List<String>.from(e["imageUrl"]) : [],
      likes: likesValue,
      comments: commentsValue,
    );
  }
}