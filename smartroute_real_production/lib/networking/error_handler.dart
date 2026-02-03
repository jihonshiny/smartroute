import 'package:flutter/material.dart';
import '../utils/logger.dart';

class ApiError {
  final int? statusCode;
  final String message;
  final String? details;
  final DateTime timestamp;

  const ApiError({
    this.statusCode,
    required this.message,
    this.details,
    required this.timestamp,
  });

  factory ApiError.network(String message) {
    return ApiError(
      message: message,
      details: 'Network connection failed',
      timestamp: DateTime.now(),
    );
  }

  factory ApiError.timeout() {
    return ApiError(
      statusCode: 408,
      message: 'Request timeout',
      details: 'The request took too long to complete',
      timestamp: DateTime.now(),
    );
  }

  factory ApiError.server(int statusCode, String message) {
    return ApiError(
      statusCode: statusCode,
      message: message,
      details: 'Server error',
      timestamp: DateTime.now(),
    );
  }

  factory ApiError.unauthorized() {
    return ApiError(
      statusCode: 401,
      message: 'Unauthorized',
      details: 'Authentication required',
      timestamp: DateTime.now(),
    );
  }

  factory ApiError.forbidden() {
    return ApiError(
      statusCode: 403,
      message: 'Forbidden',
      details: 'Access denied',
      timestamp: DateTime.now(),
    );
  }

  factory ApiError.notFound() {
    return ApiError(
      statusCode: 404,
      message: 'Not found',
      details: 'The requested resource was not found',
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ApiError(statusCode: $statusCode, message: $message, details: $details)';
  }
}

class ErrorHandler {
  static void handle(dynamic error, StackTrace? stackTrace, BuildContext? context) {
    AppLogger.error('Error occurred', error: error, stackTrace: stackTrace);

    if (context != null && context.mounted) {
      final message = _getErrorMessage(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static String _getErrorMessage(dynamic error) {
    if (error is ApiError) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception:', '').trim();
    } else {
      return 'An unexpected error occurred';
    }
  }

  static bool isNetworkError(dynamic error) {
    return error.toString().contains('SocketException') ||
        error.toString().contains('HandshakeException') ||
        error.toString().contains('NetworkError');
  }

  static bool isTimeoutError(dynamic error) {
    return error.toString().contains('TimeoutException');
  }
}
