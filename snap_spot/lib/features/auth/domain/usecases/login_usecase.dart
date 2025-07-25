import '../entities/user_token.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserToken> call(String email, String password) {
    return repository.login(email, password);
  }
}
