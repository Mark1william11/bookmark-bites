import 'package:dio/dio.dart';

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  // Generic method to perform GET requests
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      // TheMealDB API returns data in a map, which is what we need.
      return response.data;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      // For now, we'll just rethrow them to be caught by the repository/provider.
      rethrow;
    } catch (e) {
      // Handle other potential errors
      rethrow;
    }
  }
}