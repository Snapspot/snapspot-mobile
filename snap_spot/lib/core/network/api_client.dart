import 'dart:convert';
import 'package:http/http.dart' as http;

import '../error/network_exceptions.dart';

class ApiClient {
  final http.Client _client;

  ApiClient([http.Client? client]) : _client = client ?? http.Client();

  http.Client get client => _client;

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is! Map<String, dynamic>) {
          throw ParsingException('Invalid JSON structure');
        }

        return decoded;
      } else {
        final msg = _extractErrorMessage(response.body) ?? 'Unknown server error';
        // Ném ServerException trực tiếp, không wrap
        throw ServerException(response.statusCode, msg);
      }
    } on ServerException {
      // Ném lại ServerException mà không wrap
      rethrow;
    } on ParsingException {
      // Ném lại ParsingException mà không wrap
      rethrow;
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ParsingException('Format error: ${e.message}');
    } catch (e) {
      // Chỉ wrap những exception không mong muốn khác
      throw Exception('Unexpected error: $e');
    }
  }

  String? _extractErrorMessage(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
        return decoded['message'] as String;
      }
    } catch (_) {}
    return null;
  }
}