  import 'package:flutter/foundation.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  
  import '../../../profile/domain/model/user_model.dart';
  import '../../data/datasources/auth_remote_datasource.dart';
  import '../../data/models/login_request.dart';
  import '../../data/models/register_request.dart';
  import '../../../../core/network/api_client.dart';
  
  // Enum cho trạng thái authentication
  enum AuthStatus {
    uninitialized,
    authenticated,
    unauthenticated,
    loading,
  }
  
  // Exception classes
  class AuthException implements Exception {
    final String message;
    final String code;
  
    AuthException(this.message, this.code);
  
    @override
    String toString() => 'AuthException: $message (Code: $code)';
  }
  
  class NetworkException extends AuthException {
    NetworkException(String message) : super(message, 'NETWORK_ERROR');
  }
  
  class InvalidCredentialsException extends AuthException {
    InvalidCredentialsException() : super('Email hoặc mật khẩu không đúng', 'INVALID_CREDENTIALS');
  }
  
  class UserAlreadyExistsException extends AuthException {
    UserAlreadyExistsException() : super('Email đã được sử dụng', 'USER_EXISTS');
  }
  
  class AuthProvider with ChangeNotifier {
    // Private fields
    User? _user;
    AuthStatus _status = AuthStatus.uninitialized;
    String? _accessToken;
    String? _refreshToken;
    String? _errorMessage;
  
    // Dependencies
    late final AuthRemoteDataSource _authRemoteDataSource;
    late final ApiClient _apiClient;
  
    // API configuration
    static const String _baseUrl = 'http://14.225.217.24:8080/api';
    static const String _userProfileEndpoint = '/users/profile';
  
    // SharedPreferences keys
    static const String _accessTokenKey = 'accessToken';
    static const String _refreshTokenKey = 'refreshToken';
    static const String _userKey = 'user_data';
  
    // Getters
    User? get user => _user;
    AuthStatus get status => _status;
    bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;
    bool get isLoading => _status == AuthStatus.loading;
    String? get accessToken => _accessToken;
    String? get errorMessage => _errorMessage;
  
    // Constructor
    AuthProvider() {
      _apiClient = ApiClient();
      _authRemoteDataSource = AuthRemoteDataSourceImpl(client: _apiClient);
      _initializeAuth();
    }
  
    // Initialize authentication state
    Future<void> _initializeAuth() async {
      try {
        _setStatus(AuthStatus.loading);
  
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString(_accessTokenKey);
        final refreshToken = prefs.getString(_refreshTokenKey);
        final userJson = prefs.getString(_userKey);
  
        if (accessToken != null) {
          _accessToken = accessToken;
          _refreshToken = refreshToken;
  
          // Nếu có user data được lưu, load nó
          if (userJson != null) {
            try {
              _user = User.fromJson(jsonDecode(userJson));
            } catch (e) {
              debugPrint('Error parsing saved user data: $e');
            }
          }
  
          // Verify token is still valid bằng cách lấy thông tin user
          final isValid = await _fetchUserProfile();
          if (isValid) {
            _setStatus(AuthStatus.authenticated);
          } else {
            await _clearLocalData();
            _setStatus(AuthStatus.unauthenticated);
          }
        } else {
          _setStatus(AuthStatus.unauthenticated);
        }
      } catch (e) {
        debugPrint('Error initializing auth: $e');
        await _clearLocalData();
        _setStatus(AuthStatus.unauthenticated);
      }
    }
  
    // Login method - Fixed error handling
    Future<bool> login(String email, String password) async {
      try {
        _setStatus(AuthStatus.loading);
        _clearError();
  
        // Validate input
        if (email.trim().isEmpty || password.trim().isEmpty) {
          throw AuthException('Email và mật khẩu không được để trống', 'EMPTY_FIELDS');
        }
  
        // Gọi API login thông qua existing datasource
        final loginRequest = LoginRequest(email: email.trim(), password: password.trim());
        final loginResponse = await _authRemoteDataSource.login(loginRequest);
  
        // Lưu tokens
        _accessToken = loginResponse.accessToken;
        _refreshToken = loginResponse.refreshToken;
  
        // Lưu tokens vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_accessTokenKey, _accessToken!);
        if (_refreshToken != null) {
          await prefs.setString(_refreshTokenKey, _refreshToken!);
        }
  
        // Lấy thông tin user profile
        final userFetched = await _fetchUserProfile();
        if (userFetched) {
          _setStatus(AuthStatus.authenticated);
          return true;
        } else {
          await _clearLocalData();
          _setStatus(AuthStatus.unauthenticated);
          throw AuthException('Không thể lấy thông tin người dùng', 'PROFILE_FETCH_FAILED');
        }
      } catch (e) {
        _setStatus(AuthStatus.unauthenticated);
  
        // Debug log
        debugPrint('Login error: $e');
        debugPrint('Error type: ${e.runtimeType}');
  
        // Improved error handling
        String errorMessage = e.toString();
  
        // Check for specific error patterns
        if (errorMessage.contains('401') ||
            errorMessage.contains('Unauthorized') ||
            errorMessage.contains('Invalid credentials') ||
            errorMessage.contains('Login failed') ||
            errorMessage.contains('wrong password') ||
            errorMessage.contains('incorrect password')) {
          _setError('Email hoặc mật khẩu không đúng');
          throw InvalidCredentialsException();
        }
  
        if (errorMessage.contains('404') || errorMessage.contains('User not found')) {
          _setError('Tài khoản không tồn tại');
          throw AuthException('Tài khoản không tồn tại', 'USER_NOT_FOUND');
        }
  
        if (errorMessage.contains('network') ||
            errorMessage.contains('connection') ||
            errorMessage.contains('timeout')) {
          _setError('Lỗi kết nối mạng');
          throw NetworkException('Lỗi kết nối mạng');
        }
  
        // For any other error, show the actual error message
        _setError('Đăng nhập thất bại: ${_extractErrorMessage(errorMessage)}');
        throw AuthException(_extractErrorMessage(errorMessage), 'LOGIN_FAILED');
      }
    }
  
    // Register method - Fixed error handling
    Future<bool> register({
      required String email,
      required String password,
      required String confirmPassword,
      required String phoneNumber,
      required String dob,
    }) async {
      try {
        _setStatus(AuthStatus.loading);
        _clearError();
  
        // Validate input
        if (email.trim().isEmpty || password.trim().isEmpty) {
          throw AuthException('Email và mật khẩu không được để trống', 'EMPTY_FIELDS');
        }
  
        if (password != confirmPassword) {
          throw AuthException('Mật khẩu xác nhận không khớp', 'PASSWORD_MISMATCH');
        }
  
        // Gọi API register thông qua existing datasource
        final registerRequest = RegisterRequest(
          email: email.trim(),
          password: password.trim(),
          confirmPassword: confirmPassword.trim(),
          phoneNumber: phoneNumber.trim(),
          dob: dob.trim(),
        );
  
        await _authRemoteDataSource.register(registerRequest);
  
        // Sau khi đăng ký thành công, tự động đăng nhập
        final loginSuccess = await login(email, password);
        return loginSuccess;
      } catch (e) {
        _setStatus(AuthStatus.unauthenticated);
  
        debugPrint('Register error: $e');
  
        String errorMessage = e.toString();
  
        if (errorMessage.contains('Email đã được sử dụng') ||
            errorMessage.contains('already exists') ||
            errorMessage.contains('409')) {
          _setError('Email đã được sử dụng');
          throw UserAlreadyExistsException();
        }
  
        if (errorMessage.contains('network') || errorMessage.contains('connection')) {
          _setError('Lỗi kết nối mạng');
          throw NetworkException('Lỗi kết nối mạng');
        }
  
        // Ném lại exception với message từ server
        _setError('Đăng ký thất bại: ${_extractErrorMessage(errorMessage)}');
        throw AuthException(_extractErrorMessage(errorMessage), 'REGISTER_FAILED');
      }
    }
  
    // Logout method
    Future<void> logout() async {
      try {
        _setStatus(AuthStatus.loading);
        _clearError();
  
        // Có thể thêm API call logout ở đây nếu backend hỗ trợ
        // await _callLogoutAPI();
  
      } catch (e) {
        debugPrint('Error during logout: $e');
      } finally {
        await _clearLocalData();
        _setStatus(AuthStatus.unauthenticated);
      }
    }
  
    // Fetch user profile from API
    Future<bool> _fetchUserProfile() async {
      try {
        if (_accessToken == null) return false;
  
        final response = await http.get(
          Uri.parse('$_baseUrl$_userProfileEndpoint'),
          headers: {
            'Authorization': 'Bearer $_accessToken',
            'Content-Type': 'application/json',
          },
        );
  
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
  
          // Kiểm tra response structure
          if (data['success'] == true && data['data'] != null) {
            _user = User.fromJson(data['data']);
  
            // Lưu user data vào SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_userKey, jsonEncode(data['data']));
  
            return true;
          }
        }
  
        return false;
      } catch (e) {
        debugPrint('Error fetching user profile: $e');
        return false;
      }
    }
  
    // Refresh user profile manually
    Future<bool> refreshUserProfile() async {
      if (_status != AuthStatus.authenticated) return false;
  
      _setStatus(AuthStatus.loading);
      final success = await _fetchUserProfile();
      _setStatus(success ? AuthStatus.authenticated : AuthStatus.unauthenticated);
      return success;
    }
  
    // Update user profile
    Future<bool> updateProfile({
      String? name,
      String? bio,
      String? phone,
      String? birthdate,
      String? avatarUrl,
      String? backgroundUrl,
    }) async {
      try {
        if (_accessToken == null || _user == null) return false;
  
        _setStatus(AuthStatus.loading);
  
        // Tạo body request với những field cần update
        final Map<String, dynamic> updateData = {};
        if (name != null) updateData['name'] = name;
        if (bio != null) updateData['bio'] = bio;
        if (phone != null) updateData['phone'] = phone;
        if (birthdate != null) updateData['birthdate'] = birthdate;
        if (avatarUrl != null) updateData['avatarUrl'] = avatarUrl;
        if (backgroundUrl != null) updateData['backgroundUrl'] = backgroundUrl;
  
        final response = await http.put(
          Uri.parse('$_baseUrl$_userProfileEndpoint'),
          headers: {
            'Authorization': 'Bearer $_accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(updateData),
        );
  
        if (response.statusCode == 200) {
          // Refresh user profile sau khi update
          await _fetchUserProfile();
          _setStatus(AuthStatus.authenticated);
          return true;
        } else {
          _setStatus(AuthStatus.authenticated);
          throw AuthException('Cập nhật thông tin thất bại', 'UPDATE_FAILED');
        }
      } catch (e) {
        _setStatus(AuthStatus.authenticated);
        debugPrint('Error updating profile: $e');
        return false;
      }
    }
  
    // Private helper methods
    Future<void> _clearLocalData() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userKey);
  
      _accessToken = null;
      _refreshToken = null;
      _user = null;
    }
  
    void _setStatus(AuthStatus status) {
      _status = status;
      notifyListeners();
    }
  
    void _setError(String message) {
      _errorMessage = message;
      notifyListeners();
    }
  
    void _clearError() {
      _errorMessage = null;
      notifyListeners();
    }
  
    String _extractErrorMessage(String fullError) {
      // Remove common prefixes
      String cleaned = fullError
          .replaceAll('Exception: ', '')
          .replaceAll('AuthException: ', '')
          .replaceAll('NetworkException: ', '')
          .replaceAll('HttpException: ', '');
  
      // If too long, take first part
      if (cleaned.length > 100) {
        cleaned = cleaned.substring(0, 100) + '...';
      }
  
      return cleaned;
    }
  
    // Utility method for making authenticated requests
    Future<http.Response> makeAuthenticatedRequest({
      required String method,
      required String endpoint,
      Map<String, dynamic>? body,
      Map<String, String>? headers,
    }) async {
      if (_accessToken == null) {
        throw AuthException('Không có token xác thực', 'NO_TOKEN');
      }
  
      final requestHeaders = {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
        ...?headers,
      };
  
      final uri = Uri.parse('$_baseUrl$endpoint');
      http.Response response;
  
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: requestHeaders);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: requestHeaders);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }
  
      // Handle token expiration
      if (response.statusCode == 401) {
        await logout();
        throw AuthException('Token hết hạn', 'TOKEN_EXPIRED');
      }
  
      return response;
    }
  
    // Additional getters
    bool get hasValidSession => _accessToken != null && _user != null;
    String get userDisplayName => _user?.fullName ?? 'User';
    String get userAvatarUrl => _user?.avatarUrl ?? '';
    String get userEmail => _user?.email ?? '';
  }