import '../entities/user_token.dart';

abstract class AuthRepository {
  Future<UserToken> login(String email, String password);

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String dob,
  });
}
