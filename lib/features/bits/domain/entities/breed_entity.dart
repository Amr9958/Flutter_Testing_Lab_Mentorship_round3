import 'package:equatable/equatable.dart';

/// Breed Entity - Domain layer model for dog breeds
class BreedEntity extends Equatable {
  final String id;
  final String name;
  final String? breedGroup;
  final String? bredFor;
  final String? temperament;
  final String? lifeSpan;
  final String? origin;
  final String? weight; // in kg
  final String? height; // in cm
  final String? imageUrl;

  const BreedEntity({
    required this.id,
    required this.name,
    this.breedGroup,
    this.bredFor,
    this.temperament,
    this.lifeSpan,
    this.origin,
    this.weight,
    this.height,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        breedGroup,
        bredFor,
        temperament,
        lifeSpan,
        origin,
        weight,
        height,
        imageUrl,
      ];
}
