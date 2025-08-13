import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/env.dart';
import '../../../core/error/network_exceptions.dart';
import '../../../features/community/domain/models/comment_model.dart';
import '../../../features/community/domain/models/post_model.dart';

class CommunityRepository {
  final String baseUrl = Env.baseUrl;
  final String? accessToken;

  // Constructor nhận access token
  CommunityRepository({this.accessToken});

  Future<List<Post>> fetchPostsBySpotId(String spotId) async {
    try {
      final url = Uri.parse('$baseUrl/posts/$spotId');

      // Thêm headers với token nếu có
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          final List data = jsonBody['data'];
          if (data.isEmpty) return [];
          return data.map((e) => Post.fromApi(e)).toList();
        }
        return [];
      } else {
        throw NetworkException('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw NetworkException('Lỗi khi tải bài đăng: ${e.toString()}');
    }
  }

  Future<bool> likePost(String postId) async {
    try {
      // Kiểm tra token trước khi gọi API
      if (accessToken == null) {
        throw NetworkException('Vui lòng đăng nhập để thích bài đăng');
      }

      final url = Uri.parse('$baseUrl/posts/$postId/like');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      print('Calling like API: $url');
      print('With token: ${accessToken?.substring(0, 20)}...');

      final response = await http.post(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true) {
          return true;
        }
      }

      if (response.statusCode == 400) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['message']?.toString().toLowerCase().contains('already liked') ?? false) {
          return true; // Treat as success
        }
      }


      // Xử lý các lỗi cụ thể
      if (response.statusCode == 401) {
        throw NetworkException('Token hết hạn, vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw NetworkException('Bài đăng không tồn tại');
      } else {
        throw NetworkException('Lỗi server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error in likePost: $e');
      rethrow; // Ném lại exception để UI có thể xử lý
    }
  }

  Future<bool> unlikePost(String postId) async {
    try {
      // Kiểm tra token trước khi gọi API
      if (accessToken == null) {
        throw NetworkException('Vui lòng đăng nhập để bỏ thích bài đăng');
      }

      final url = Uri.parse('$baseUrl/posts/$postId/unlike');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      print('Calling unlike API: $url');
      print('With token: ${accessToken?.substring(0, 20)}...');

      final response = await http.post(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true) {
          return true;
        }
      }

      // Xử lý các lỗi cụ thể
      if (response.statusCode == 401) {
        throw NetworkException('Token hết hạn, vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw NetworkException('Bài đăng không tồn tại');
      } else {
        throw NetworkException('Lỗi server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error in unlikePost: $e');
      rethrow; // Ném lại exception để UI có thể xử lý
    }
  }

  // Method tổng hợp để toggle like/unlike
  Future<bool> toggleLikePost(String postId, bool isCurrentlyLiked) async {
    if (isCurrentlyLiked) {
      return await unlikePost(postId);
    } else {
      return await likePost(postId);
    }
  }
  // Fetch comments for a post
  Future<List<Comment>> fetchCommentsByPostId(String postId) async {
    try {
      final url = Uri.parse('$baseUrl/posts/$postId/comments');

      // Thêm headers với token nếu có
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await http.get(url, headers: headers);

      print('Fetching comments for post: $postId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          final List data = jsonBody['data'];
          return data.map((e) => Comment.fromApi(e)).toList();
        }
        return [];
      } else if (response.statusCode == 404) {
        // No comments found - return empty list
        return [];
      } else {
        throw NetworkException('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      throw NetworkException('Lỗi khi tải bình luận: ${e.toString()}');
    }
  }

  // Post a new comment
  Future<Comment?> postComment(String postId, String content) async {
    try {
      // Kiểm tra token trước khi gọi API
      if (accessToken == null) {
        throw NetworkException('Vui lòng đăng nhập để bình luận');
      }

      if (content
          .trim()
          .isEmpty) {
        throw NetworkException('Nội dung bình luận không được để trống');
      }

      final url = Uri.parse('$baseUrl/posts/$postId/comments');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final body = json.encode({
        'content': content.trim(),
      });

      print('Posting comment to: $url');
      print('Comment content: $content');
      print('With token: ${accessToken?.substring(0, 20)}...');

      final response = await http.post(url, headers: headers, body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          return Comment.fromApi(jsonBody['data']);
        }
      }

      // Xử lý các lỗi cụ thể
      if (response.statusCode == 401) {
        throw NetworkException('Token hết hạn, vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw NetworkException('Bài đăng không tồn tại');
      } else {
        throw NetworkException(
            'Lỗi server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error posting comment: $e');
      rethrow;
    }
  }
}