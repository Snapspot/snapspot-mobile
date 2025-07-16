import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../entities/user_token.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserToken> login(String email, String password) async {
    final response = await remoteDataSource.login(LoginRequest(email: email, password: password));
    return UserToken(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String dob,
  }) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      dob: dob,
    );
    await remoteDataSource.register(request);
  }
}
