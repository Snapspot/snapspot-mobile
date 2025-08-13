import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/env.dart';
import '../../../core/error/network_exceptions.dart';
import '../../../features/community/domain/models/comment_model.dart';
import '../../../features/community/domain/models/post_model.dart';

class CommunityRepository {
  final String baseUrl = Env.baseUrl;
  final String? accessToken;

  CommunityRepository({this.accessToken});

  Future<List<Post>> fetchPostsBySpotId(String spotId) async {
    try {
      final url = Uri.parse('$baseUrl/posts/$spotId');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

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
      if (accessToken == null) {
        throw NetworkException('Vui lòng đăng nhập để thích bài đăng');
      }

      final url = Uri.parse('$baseUrl/posts/$postId/like');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      print('Calling like API: $url');
      final response = await http.post(url, headers: headers);

      print('Like response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true) {
          return true;
        }
      } else if (response.statusCode == 400) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['message']?.toString().toLowerCase().contains('already liked') ?? false) {
          return true; // Treat as success
        }
      }

      if (response.statusCode == 401) {
        throw NetworkException('Token hết hạn, vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw NetworkException('Bài đăng không tồn tại');
      } else {
        throw NetworkException('Lỗi server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error in likePost: $e');
      rethrow;
    }
  }

  Future<bool> unlikePost(String postId) async {
    try {
      if (accessToken == null) {
        throw NetworkException('Vui lòng đăng nhập để bỏ thích bài đăng');
      }

      final url = Uri.parse('$baseUrl/posts/$postId/unlike');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      print('Calling unlike API: $url');
      final response = await http.post(url, headers: headers);

      print('Unlike response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true) {
          return true;
        }
      }

      if (response.statusCode == 401) {
        throw NetworkException('Token hết hạn, vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw NetworkException('Bài đăng không tồn tại');
      } else {
        throw NetworkException('Lỗi server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error in unlikePost: $e');
      rethrow;
    }
  }

  Future<bool> toggleLikePost(String postId, bool isCurrentlyLiked) async {
    if (isCurrentlyLiked) {
      return await unlikePost(postId);
    } else {
      return await likePost(postId);
    }
  }

  Future<bool> checkLikeStatus(String postId) async {
    try {
      if (accessToken == null) {
        return false; // Chưa đăng nhập, mặc định chưa like
      }

      final url = Uri.parse('$baseUrl/posts/$postId/like');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      print('Checking like status for post: $postId');
      final response = await http.post(url, headers: headers);

      print('Check like status response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Like thành công => post chưa được like, rollback bằng unlike
        final unlikeResponse = await http.post(
          Uri.parse('$baseUrl/posts/$postId/unlike'),
          headers: headers,
        );
        print('Rollback unlike response: ${unlikeResponse.statusCode} - ${unlikeResponse.body}');
        return false; // Chưa like ban đầu
      } else if (response.statusCode == 400) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['message']?.toString().toLowerCase().contains('already liked') ?? false) {
          return true; // Đã like
        }
        throw NetworkException('Lỗi khi kiểm tra trạng thái like: ${response.body}');
      } else if (response.statusCode == 401) {
        throw NetworkException('Token hết hạn, vui lòng đăng nhập lại');
      } else {
        throw NetworkException('Lỗi server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error in checkLikeStatus: $e');
      return false; // Fallback: chưa like nếu lỗi
    }
  }

  Future<List<Comment>> fetchCommentsByPostId(String postId) async {
    try {
      final url = Uri.parse('$baseUrl/posts/$postId/comments');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

      print('Fetching comments for post: $postId');
      final response = await http.get(url, headers: headers);

      print('Comments response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          final List data = jsonBody['data'];
          return data.map((e) => Comment.fromApi(e)).toList();
        }
        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw NetworkException('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      throw NetworkException('Lỗi khi tải bình luận: ${e.toString()}');
    }
  }

  Future<Comment?> postComment(String postId, String content) async {
    try {
      if (accessToken == null) {
        throw NetworkException('Vui lòng đăng nhập để bình luận');
      }

      if (content.trim().isEmpty) {
        throw NetworkException('Nội dung bình luận không được để trống');
      }

      final url = Uri.parse('$baseUrl/posts/$postId/comments');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = json.encode({'content': content.trim()});

      print('Posting comment to: $url');
      print('Comment content: $content');
      final response = await http.post(url, headers: headers, body: body);

      print('Post comment response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          return Comment.fromApi(jsonBody['data']);
        }
      }

      if (response.statusCode == 401) {
        throw NetworkException('Token hết hạn, vui lòng đăng nhập lại');
      } else if (response.statusCode == 404) {
        throw NetworkException('Bài đăng không tồn tại');
      } else {
        throw NetworkException('Lỗi server (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error posting comment: $e');
      rethrow;
    }
  }
}