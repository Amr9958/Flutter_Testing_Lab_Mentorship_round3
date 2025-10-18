import 'package:equatable/equatable.dart';

/// Pet Entity - Domain layer model
/// Pure business logic model with no external dependencies
class PetEntity extends Equatable {
  final String id;
  final String name;
  final String breed;
  final String category;
  final int age;
  final String gender;
  final double weight;
  final String color;
  final String location;
  final String description;
  final String imageUrl;
  final bool isFavorite;
  final double distance;

  const PetEntity({
    required this.id,
    required this.name,
    required this.breed,
    required this.category,
    required this.age,
    required this.gender,
    required this.weight,
    required this.color,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
    required this.distance,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        breed,
        category,
        age,
        gender,
        weight,
        color,
        location,
        description,
        imageUrl,
        isFavorite,
        distance,
      ];
}
