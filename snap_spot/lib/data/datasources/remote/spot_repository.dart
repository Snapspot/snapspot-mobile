
import '../../../config/env.dart';
import '../../../core/error/network_exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../features/home/domain/models/spot_model.dart';

class SpotRepository {
  final ApiClient _apiClient;

  SpotRepository([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  Future<List<SpotModel>> fetchSpots() async {
    final response = await _apiClient.get(
      '${Env.baseUrl}/spots',
      headers: {'Content-Type': 'application/json'},
    );

    final data = response['data'];
    if (data is! List) {
      throw ParsingException('Expected a list in "data" field');
    }

    return data.map((e) => SpotModel.fromJson(e)).toList();
  }

  Future<List<SpotModel>> fetchSpotsByLocation(double latitude, double longitude) async {
    final url = '${Env.baseUrl}/spots/distance?latitude=$latitude&longitude=$longitude';

    final response = await _apiClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final data = response['data'];
    if (data is! List) {
      throw ParsingException('Expected a list in "data" field');
    }

    return data.map((e) => SpotModel.fromJson(e)).toList();
  }

  Future<SpotModel> fetchSpotById(String spotId) async {
    final url = '${Env.baseUrl}/spots/$spotId';

    final response = await _apiClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final data = response['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw ParsingException('Expected a JSON object in "data" field');
    }

    return SpotModel.fromJson(data);
  }

}
