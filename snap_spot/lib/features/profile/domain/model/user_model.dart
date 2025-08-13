// class User {
//   final String name;
//   final String email;
//   final String phone;
//   final String birthdate;
//   final String avatarUrl;
//   final String backgroundUrl;
//   final String bio;
//   final List<String> posts;
//   final List<String> savedPosts;
//
//   User({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.birthdate,
//     required this.avatarUrl,
//     required this.backgroundUrl,
//     required this.bio,
//     required this.posts,
//     required this.savedPosts,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       birthdate: json['birthdate'],
//       avatarUrl: json['avatarUrl'],
//       backgroundUrl: json['backgroundUrl'],
//       bio: json['bio'],
//       posts: List<String>.from(json['posts']),
//       savedPosts: List<String>.from(json['savedPosts']),
//     );
//   }
// }
class User {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime dob;
  final String roleName;
  final String? avatarUrl;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.roleName,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String? ?? '', // Mặc định chuỗi rỗng nếu null
      fullName: json['fullName'] as String? ?? '', // Mặc định chuỗi rỗng nếu null
      email: json['email'] as String? ?? '', // Mặc định chuỗi rỗng nếu null
      phoneNumber: json['phoneNumber'] as String? ?? '', // Mặc định chuỗi rỗng nếu null
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : DateTime.now(), // Mặc định là ngày hiện tại nếu null
      roleName: json['roleName'] as String? ?? '', // Mặc định chuỗi rỗng nếu null
      avatarUrl: json['avatarUrl'] as String?, // Có thể là null nếu không có
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dob': dob.toIso8601String(),
      'roleName': roleName,
      'avatarUrl': avatarUrl ?? '',
    };
  }
}
