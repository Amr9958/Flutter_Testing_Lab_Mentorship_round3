import 'package:equatable/equatable.dart';
import 'package:animals_store/features/bits/domain/entities/breed_entity.dart';
import 'package:animals_store/features/bits/domain/entities/dog_image_entity.dart';
import 'package:animals_store/features/bits/domain/entities/source_entity.dart';

/// Base state for Dog feature
abstract class DogState extends Equatable {
  const DogState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DogInitial extends DogState {}

/// Loading state
class DogLoading extends DogState {}

/// Breeds loaded state
class BreedsLoaded extends DogState {
  final List<BreedEntity> breeds;

  const BreedsLoaded(this.breeds);

  @override
  List<Object?> get props => [breeds];
}

/// Dog images loaded state
class DogImagesLoaded extends DogState {
  final List<DogImageEntity> images;

  const DogImagesLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

/// Sources loaded state
class SourcesLoaded extends DogState {
  final List<SourceEntity> sources;

  const SourcesLoaded(this.sources);

  @override
  List<Object?> get props => [sources];
}

/// Error state
class DogError extends DogState {
  final String message;

  const DogError(this.message);

  @override
  List<Object?> get props => [message];
}
