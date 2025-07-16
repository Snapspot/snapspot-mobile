class FeedbackModel {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}