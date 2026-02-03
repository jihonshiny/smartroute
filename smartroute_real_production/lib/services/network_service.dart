import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final _client = http.Client();
  final Duration timeout = const Duration(seconds: 30);

  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .get(Uri.parse(url), headers: headers)
          .timeout(timeout);
      return response;
    } catch (e) {
      throw NetworkException('GET request failed: $e');
    }
  }

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await _client
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(timeout);
      return response;
    } catch (e) {
      throw NetworkException('POST request failed: $e');
    }
  }

  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await _client
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(timeout);
      return response;
    } catch (e) {
      throw NetworkException('PUT request failed: $e');
    }
  }

  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .delete(Uri.parse(url), headers: headers)
          .timeout(timeout);
      return response;
    } catch (e) {
      throw NetworkException('DELETE request failed: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}
