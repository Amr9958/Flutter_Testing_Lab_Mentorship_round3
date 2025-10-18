import 'package:dio/dio.dart';
import 'package:animals_store/core/error/exceptions.dart';
import 'package:animals_store/core/network/api_constants.dart';
import 'package:animals_store/core/network/dio_interceptor.dart';

/// Dio HTTP client wrapper for API calls
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
          ApiConstants.apiKeyHeader: ApiConstants.apiKey, // Add Dog API key
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(DioInterceptor());

    // Add logging interceptor in debug mode
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to custom exceptions
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please try again.',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const AppException(
          message: 'Request cancelled.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return const ServerException(
          message: 'Invalid SSL certificate.',
        );

      case DioExceptionType.unknown:
        return AppException(
          message: error.message ?? 'An unexpected error occurred.',
        );
    }
  }

  /// Handle HTTP response errors
  AppException _handleResponseError(Response? response) {
    final statusCode = response?.statusCode;
    final message = response?.data?['message'] ?? 'An error occurred';

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          statusCode: statusCode,
        );
      case 401:
        return AuthException(
          message: 'Unauthorized. Please login again.',
          statusCode: statusCode,
        );
      case 403:
        return AuthException(
          message: 'Access forbidden.',
          statusCode: statusCode,
        );
      case 404:
        return NotFoundException(
          message: message,
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );
      default:
        return ServerException(
          message: message,
          statusCode: statusCode,
        );
    }
  }

  /// Set API key (if needed to change dynamically)
  void setApiKey(String apiKey) {
    _dio.options.headers[ApiConstants.apiKeyHeader] = apiKey;
  }

  /// Remove API key
  void removeApiKey() {
    _dio.options.headers.remove(ApiConstants.apiKeyHeader);
  }
}
