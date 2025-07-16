import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/env.dart';
import '../../../core/network/api_client.dart';
import '../../../core/error/network_exceptions.dart';
import '../domain/models/agency_model.dart';

class AgencyRepository {
  final ApiClient _apiClient;

  AgencyRepository([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  Future<List<AgencyModel>> fetchAgenciesBySpotId(String spotId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final response = await _apiClient.get(
      '${Env.baseUrl}/agencies/spot/$spotId',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = response['data'];
    if (data is! List) {
      throw ParsingException('Expected a list in "data" field');
    }

    return data.map((e) => AgencyModel.fromJson(e)).toList();
  }
}
