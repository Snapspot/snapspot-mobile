import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/env.dart';
import '../domain/models/spot_model.dart';

class SpotRepository {
  Future<List<SpotModel>> fetchSpots() async {
    try {
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/spots'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        // Kiểm tra cấu trúc response cơ bản
        if (jsonBody is! Map<String, dynamic> || jsonBody['data'] is! List) {
          throw FormatException('Invalid response format');
        }

        return (jsonBody['data'] as List)
            .map((e) => SpotModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      throw Exception('Data parsing error: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}