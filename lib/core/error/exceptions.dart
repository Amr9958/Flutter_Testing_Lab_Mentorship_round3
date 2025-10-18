/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AppException: $message (Status Code: $statusCode)';
}

/// Server exception - thrown when API call fails
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status Code: $statusCode)';
}

/// Cache exception - thrown when local data source fails
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Network exception - thrown when there's no internet connection
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Validation exception - thrown when data validation fails
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Authentication exception - thrown when auth fails
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'AuthException: $message';
}

/// Not found exception - thrown when resource is not found
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
  });

  @override
  String toString() => 'NotFoundException: $message';
}
