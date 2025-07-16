import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String dob,
  }) {
    return repository.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      dob: dob,
    );
  }
}
