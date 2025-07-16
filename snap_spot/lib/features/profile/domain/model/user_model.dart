class User {
  final String name;
  final String email;
  final String phone;
  final String birthdate;
  final String avatarUrl;
  final String backgroundUrl;
  final String bio;
  final List<String> posts;
  final List<String> savedPosts;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.avatarUrl,
    required this.backgroundUrl,
    required this.bio,
    required this.posts,
    required this.savedPosts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthdate: json['birthdate'],
      avatarUrl: json['avatarUrl'],
      backgroundUrl: json['backgroundUrl'],
      bio: json['bio'],
      posts: List<String>.from(json['posts']),
      savedPosts: List<String>.from(json['savedPosts']),
    );
  }
}
