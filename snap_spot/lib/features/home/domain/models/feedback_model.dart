// lib/features/feedbacks/data/models/feedback_model.dart

class FeedbackModel {
  final String id;
  final String spotId;
  final String agencyId;
  final String userId;
  final String fullName;
  final String avatarUrl;
  final String content;
  final int rating;
  final DateTime createdAt;
  final bool isApproved;
  final bool isDeleted;

  FeedbackModel({
    required this.id,
    required this.spotId,
    required this.agencyId,
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.content,
    required this.rating,
    required this.createdAt,
    this.isApproved = false,
    this.isDeleted = false,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      spotId: json['spotId'] ?? '', // Might not be present in agency feedback
      agencyId: json['agencyId'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['userName'] ?? '', // Note: API uses 'userName' not 'fullName'
      avatarUrl: json['avatarUrl'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isApproved: json['isApproved'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spotId': spotId,
      'agencyId': agencyId,
      'userId': userId,
      'userName': fullName,
      'avatarUrl': avatarUrl,
      'content': content,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'isApproved': isApproved,
      'isDeleted': isDeleted,
    };
  }
}