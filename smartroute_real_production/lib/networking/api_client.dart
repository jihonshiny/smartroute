import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/config.dart';
import '../utils/logger.dart';

class ApiClient {
  final http.Client _client;
  final String _baseUrl;
  final Map<String, String> _defaultHeaders;

  ApiClient({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.kakaoMapApiUrl,
        _defaultHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      AppLogger.debug('GET $uri');

      final response = await _client.get(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e, stackTrace) {
      AppLogger.error('GET request failed', error: e, stackTrace: stackTrace);
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      AppLogger.debug('POST $uri');

      final response = await _client.post(
        uri,
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e, stackTrace) {
      AppLogger.error('POST request failed', error: e, stackTrace: stackTrace);
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      AppLogger.debug('PUT $uri');

      final response = await _client.put(
        uri,
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e, stackTrace) {
      AppLogger.error('PUT request failed', error: e, stackTrace: stackTrace);
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      AppLogger.debug('DELETE $uri');

      final response = await _client.delete(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e, stackTrace) {
      AppLogger.error('DELETE request failed', error: e, stackTrace: stackTrace);
      return ApiResponse.error('Network error: $e');
    }
  }

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    return Uri.parse('$_baseUrl$endpoint').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    AppLogger.debug('Response status: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return ApiResponse<T>.success(null);
      }

      try {
        final jsonData = jsonDecode(response.body);
        
        if (fromJson != null) {
          final data = fromJson(jsonData as Map<String, dynamic>);
          return ApiResponse<T>.success(data);
        }

        return ApiResponse<T>.success(jsonData as T);
      } catch (e) {
        AppLogger.error('JSON parse error', error: e);
        return ApiResponse<T>.error('Failed to parse response');
      }
    } else {
      String errorMessage = 'Request failed with status: ${response.statusCode}';
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (_) {}
      
      AppLogger.warning(errorMessage);
      return ApiResponse<T>.error(errorMessage);
    }
  }

  void close() {
    _client.close();
  }
}

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const ApiResponse({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory ApiResponse.success(T? data) {
    return ApiResponse(data: data, isSuccess: true);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(error: error, isSuccess: false);
  }
}
