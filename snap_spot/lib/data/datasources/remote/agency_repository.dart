import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/env.dart';
import '../../../core/network/api_client.dart';
import '../../../core/error/network_exceptions.dart';
import '../../../features/home/domain/models/agency_model.dart';

class AgencyRepository {
  final ApiClient _apiClient;

  AgencyRepository([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  Future<List<AgencyModel>> fetchAgenciesBySpotId(String spotId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    // Ném exception cụ thể khi không có token
    if (token == null || token.isEmpty) {
      throw ServerException(401, 'Vui lòng đăng nhập để xem danh sách công ty dịch vụ');
    }

    try {
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
    } on ServerException catch (e) {
      // Xử lý ServerException
      if (e.statusCode == 401) {
        throw ServerException(401, 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại');
      }
      // Ném lại ServerException khác
      rethrow;
    } on NetworkException {
      // Ném lại NetworkException
      rethrow;
    } on ParsingException {
      // Ném lại ParsingException
      rethrow;
    } catch (e) {
      // Log lỗi không mong muốn để debug
      print('Unexpected error in fetchAgenciesBySpotId: $e');
      print('Error type: ${e.runtimeType}');
      rethrow;
    }
  }
}