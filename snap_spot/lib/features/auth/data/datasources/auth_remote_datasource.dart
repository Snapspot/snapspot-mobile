import 'dart:convert';

import '../../../../core/network/api_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await client.client.post(
    Uri.parse('http://14.225.217.24:8080/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  @override
  Future<void> register(RegisterRequest request) async {
    final response = await client.client.post(
    Uri.parse('http://14.225.217.24:8080/api/v1/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200 || decoded['success'] != true) {
      final detailErrors = decoded['listDetailError'];
      final firstError = (detailErrors is List && detailErrors.isNotEmpty)
          ? detailErrors.first['message'] ?? 'Đăng ký thất bại'
          : decoded['message'] ?? 'Đăng ký thất bại';
      throw Exception(firstError);
    }
  }
}
