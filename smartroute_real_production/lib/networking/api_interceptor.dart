import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/logger.dart';

class ApiInterceptor {
  final http.Client client;
  final List<RequestInterceptor> requestInterceptors;
  final List<ResponseInterceptor> responseInterceptors;

  ApiInterceptor({
    required this.client,
    this.requestInterceptors = const [],
    this.responseInterceptors = const [],
  });

  Future<http.Response> send(http.BaseRequest request) async {
    var modifiedRequest = request;

    for (final interceptor in requestInterceptors) {
      modifiedRequest = await interceptor.onRequest(modifiedRequest);
    }

    AppLogger.debug('Sending ${modifiedRequest.method} ${modifiedRequest.url}');

    final streamedResponse = await client.send(modifiedRequest);
    var response = await http.Response.fromStream(streamedResponse);

    for (final interceptor in responseInterceptors) {
      response = await interceptor.onResponse(response);
    }

    return response;
  }
}

abstract class RequestInterceptor {
  Future<http.BaseRequest> onRequest(http.BaseRequest request);
}

abstract class ResponseInterceptor {
  Future<http.Response> onResponse(http.Response response);
}

class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  Future<http.BaseRequest> onRequest(http.BaseRequest request) async {
    AppLogger.info('→ ${request.method} ${request.url}');
    if (request is http.Request) {
      AppLogger.debug('Body: ${request.body}');
    }
    return request;
  }

  @override
  Future<http.Response> onResponse(http.Response response) async {
    AppLogger.info('← ${response.statusCode} ${response.request?.url}');
    return response;
  }
}

class AuthInterceptor implements RequestInterceptor {
  final String Function() getToken;

  AuthInterceptor(this.getToken);

  @override
  Future<http.BaseRequest> onRequest(http.BaseRequest request) async {
    final token = getToken();
    if (token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return request;
  }
}

class RetryInterceptor implements ResponseInterceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<http.Response> onResponse(http.Response response) async {
    if (response.statusCode >= 500 && response.statusCode < 600) {
      for (int i = 0; i < maxRetries; i++) {
        await Future.delayed(retryDelay);
        AppLogger.warning('Retrying request (attempt ${i + 1}/$maxRetries)');
        // Retry logic would go here
      }
    }
    return response;
  }
}
