import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';

/// Base class for all use cases
///
/// [T] - The return type of the use case
/// [Params] - The parameters required by the use case
abstract class UseCase<T, Params> {
  /// Execute the use case
  ///
  /// Returns [Either<Failure, T>]
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains [T] if the operation succeeds
  Future<Either<Failure, T>> call(Params params);
}

/// Use case with no parameters
abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}

/// Class to be used when no parameters are needed
class NoParams {
  const NoParams();
}
