class User {
  final String name;
  final String email;
  final String phone;
  final String birthdate;
  final String avatarUrl;
  final String backgroundUrl;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.avatarUrl,
    required this.backgroundUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthdate: json['birthdate'],
      avatarUrl: json['avatarUrl'],
      backgroundUrl: json['backgroundUrl'],
    );
  }
}
