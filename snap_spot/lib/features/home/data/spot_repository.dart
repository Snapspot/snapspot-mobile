// lib/features/home/data/spot_repository.dart

import '../../../config/env.dart';
import '../../../core/error/network_exceptions.dart';
import '../../../core/network/api_client.dart';
import '../domain/models/spot_model.dart';

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
}
