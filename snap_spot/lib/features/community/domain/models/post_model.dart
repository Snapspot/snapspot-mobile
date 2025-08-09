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
  final int comments; // Đổi tên trường này

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
    // ...existing code, nếu cần dùng cho mock...
    throw UnimplementedError();
  }

  factory Post.fromApi(Map<String, dynamic> e) {
    // Đảm bảo luôn trả về int cho likes
    int likesValue;
    if (e["likes"] is int) {
      likesValue = e["likes"];
    } else if (e["likes"] is String) {
      likesValue = int.tryParse(e["likes"]) ?? 0;
    } else {
      likesValue = 0;
    }
    int commentsValue;
    if (e["comments"] is int) {
      commentsValue = e["comments"];
    } else if (e["comments"] is String) {
      commentsValue = int.tryParse(e["comments"]) ?? 0;
    } else {
      commentsValue = 0;
    }
    return Post(
      id: e["postId"] as String,
      userName: e["user"]?["name"] ?? "",
      userAvatarUrl: e["user"]?["avatar"] ?? "",
      location: e["user"]?["spotname"] ?? "",
      timestamp: DateTime.parse(e["timestamp"]),
      content: e["content"] ?? "",
      imageUrls: (e["imageUrl"] is List)
          ? List<String>.from(e["imageUrl"])
          : [],
      likes: likesValue,
      comments: commentsValue,
    );
  }
}
