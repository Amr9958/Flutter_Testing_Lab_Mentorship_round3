import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Custom Dio interceptor for handling requests, responses, and errors
class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add custom headers or modify request before sending
    // You can add authentication tokens, custom headers, etc.

    // Example: Add timestamp to all requests
    options.headers['X-Request-Time'] = DateTime.now().toIso8601String();

    // Continue with the request
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle response data
    // You can modify response data here if needed

    // Continue with the response
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors globally
    // You can add retry logic, show global error messages, etc.

    // Log error details
    _logError(err);

    // Continue with the error
    super.onError(err, handler);
  }

  void _logError(DioException error) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔴 DIO ERROR');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('Type: ${error.type}');
      debugPrint('Message: ${error.message}');
      debugPrint('Status Code: ${error.response?.statusCode}');
      debugPrint('Data: ${error.response?.data}');
      debugPrint('Path: ${error.requestOptions.path}');
      debugPrint('Method: ${error.requestOptions.method}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }
}
