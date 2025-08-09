// lib/features/feedbacks/data/feedback_repository.dart

import 'dart:convert';

import '../../../config/env.dart';
import '../../../core/network/api_client.dart';
import '../../../core/error/network_exceptions.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart' hide NetworkException;
import '../../../features/home/domain/models/feedback_model.dart';

class FeedbackRepository {
  final ApiClient _apiClient;
  final AuthProvider _authProvider;

  FeedbackRepository(this._authProvider, [ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  Future<List<FeedbackModel>> fetchAgencyFeedbacks({
    required String agencyId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      // Kiểm tra xem user đã đăng nhập chưa
      if (!_authProvider.isAuthenticated || _authProvider.accessToken == null) {
        throw NetworkException('User not authenticated');
      }

      // Sử dụng method makeAuthenticatedRequest từ AuthProvider
      final response = await _authProvider.makeAuthenticatedRequest(
        method: 'GET',
        endpoint: '/feedback/agency/$agencyId?pageNumber=$page&pageSize=$size',
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra xem response có null không
        if (data == null) {
          throw ParsingException('Response is null');
        }

        // Kiểm tra success status
        if (data['success'] == true) {
          // Lấy data object
          final responseData = data['data'];

          if (responseData == null) {
            // Nếu data null nhưng success = true, trả về empty list
            return [];
          }

          // Kiểm tra cấu trúc response - có thể là paginated response
          if (responseData is Map<String, dynamic>) {
            // Trường hợp paginated response với items
            if (responseData.containsKey('items') && responseData['items'] is List) {
              final items = responseData['items'] as List;
              return items.map((item) => FeedbackModel.fromJson(item)).toList();
            }

            // Trường hợp có các key khác chứa list
            final content = responseData['content'] ?? responseData['feedbacks'];
            if (content is List) {
              return content.map((item) => FeedbackModel.fromJson(item)).toList();
            }
          }

          // Trường hợp data là array trực tiếp
          if (responseData is List) {
            return responseData.map((item) => FeedbackModel.fromJson(item)).toList();
          }

          // Nếu không tìm thấy valid data structure
          throw ParsingException('Invalid response structure: ${responseData.runtimeType}');
        } else {
          // Nếu success = false, throw error với message từ server
          final errorMessage = data['message'] ?? 'Unknown error from server';
          throw NetworkException(errorMessage);
        }
      } else {
        throw NetworkException('HTTP ${response.statusCode}: ${response.body}');
      }

    } catch (e) {
      print('Error fetching feedbacks: $e'); // Debug log

      // Kiểm tra các loại lỗi khác nhau
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        throw NetworkException('Authentication required. Please login again.');
      }

      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        throw NetworkException('Access forbidden. You don\'t have permission to view feedbacks.');
      }

      if (e.toString().contains('404')) {
        throw NetworkException('Agency feedbacks not found. Agency ID: $agencyId');
      }

      if (e.toString().contains('TOKEN_EXPIRED')) {
        throw NetworkException('Session expired. Please login again.');
      }

      // Rethrow ParsingException và NetworkException
      if (e is ParsingException || e is NetworkException) {
        rethrow;
      }

      // Cho các exception khác
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }
  Future<void> createFeedback({
    required String agencyId,
    required String content,
    required int rating,
  }) async {
    final response = await _authProvider.makeAuthenticatedRequest(
      method: 'POST',
      endpoint: '/feedback',
      body: {
        'content': content,
        'rating': rating,
        'agencyId': agencyId,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create feedback: ${response.body}');
    }
  }
}