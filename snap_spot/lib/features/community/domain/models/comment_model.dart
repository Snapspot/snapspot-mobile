class Comment {
  final String commentId;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String content;
  final DateTime timestamp;
  final String? spotId;
  final String? spotName;

  Comment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.content,
    required this.timestamp,
    this.spotId,
    this.spotName,
  });

  // Factory constructor từ API response
  factory Comment.fromApi(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] ?? '',
      userId: json['user']?['userId'] ?? '',
      userName: json['user']?['name'] ?? 'Unknown User',
      userAvatarUrl: json['user']?['avatar'] ?? '',
      content: json['content'] ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
      spotId: json['user']?['spotId'],
      spotName: json['user']?['spotname'],
    );
  }

  // Factory constructor từ JSON (cho local storage)
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Unknown User',
      userAvatarUrl: json['userAvatarUrl'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      spotId: json['spotId'],
      spotName: json['spotName'],
    );
  }

  // Convert to JSON (cho local storage)
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'spotId': spotId,
      'spotName': spotName,
    };
  }

  // Helper method to parse timestamp from API
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();

    if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        print('Error parsing timestamp: $timestamp, error: $e');
        return DateTime.now();
      }
    }

    return DateTime.now();
  }

  @override
  String toString() {
    return 'Comment(commentId: $commentId, userId: $userId, userName: $userName, content: $content, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.commentId == commentId;
  }

  @override
  int get hashCode => commentId.hashCode;

  // Copy with method for updating comment
  Comment copyWith({
    String? commentId,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? content,
    DateTime? timestamp,
    String? spotId,
    String? spotName,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      spotId: spotId ?? this.spotId,
      spotName: spotName ?? this.spotName,
    );
  }
}