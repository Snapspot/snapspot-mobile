class RegisterRequest {
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String dob; // ISO format

  RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.dob,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'confirmPassword': confirmPassword,
    'phoneNumber': phoneNumber,
    'dob': dob,
  };
}
