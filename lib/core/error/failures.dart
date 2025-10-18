import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Using Equatable for value equality comparison
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server-related failures (API errors, server errors, etc.)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache-related failures (local database errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network-related failures (no internet, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Validation failures (invalid input, etc.)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Authentication failures (unauthorized, token expired, etc.)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Not found failures (404, resource not found)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Unknown/Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
