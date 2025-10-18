import 'package:equatable/equatable.dart';
import 'package:animals_store/features/bits/domain/entities/breed_entity.dart';

/// Dog Image Entity - Domain layer model for dog images
class DogImageEntity extends Equatable {
  final String id;
  final String url;
  final int? width;
  final int? height;
  final List<BreedEntity>? breeds;

  const DogImageEntity({
    required this.id,
    required this.url,
    this.width,
    this.height,
    this.breeds,
  });

  @override
  List<Object?> get props => [
        id,
        url,
        width,
        height,
        breeds,
      ];
}
