import 'package:dio/dio.dart';
import 'api_exception.dart';
import '../../app/api_constants.dart';
import '../utils/logger.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    Logger.info('Token updated in ApiClient');
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Logger.request('GET', path, queryParameters);
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      Logger.response(path, response.data);
      return response.data;
    } on DioException catch (e) {
      final error = _handleDioError(e);
      Logger.error('GET FAILED: $path', error.message, e.stackTrace);
      throw error;
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    Logger.request('POST', path, data);
    try {
      final response = await _dio.post(path, data: data);
      Logger.response(path, response.data);
      return response.data;
    } on DioException catch (e) {
      final error = _handleDioError(e);
      Logger.error('POST FAILED: $path', error.message, e.stackTrace);
      throw error;
    }
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    Logger.request('PUT', path, data);
    try {
      final response = await _dio.put(path, data: data);
      Logger.response(path, response.data);
      return response.data;
    } on DioException catch (e) {
      final error = _handleDioError(e);
      Logger.error('PUT FAILED: $path', error.message, e.stackTrace);
      throw error;
    }
  }

  ApiException _handleDioError(DioException error) {
    if (error.response != null) {
      String message = 'Unknown error';
      if (error.response?.data is Map &&
          (error.response?.data as Map).containsKey('message')) {
        message = error.response?.data['message'];
      }
      return ApiException(message, statusCode: error.response?.statusCode);
    } else {
      return ApiException('Network error: ${error.message}');
    }
  }
}
