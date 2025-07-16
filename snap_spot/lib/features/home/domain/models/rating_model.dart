class RatingModel {
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double stars;
  final String comment;
  final DateTime date;

  RatingModel({
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.stars,
    required this.comment,
    required this.date,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      stars: (json['stars'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'stars': stars,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
