import 'package:equatable/equatable.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';

/// Base state for Pets
abstract class PetsState extends Equatable {
  const PetsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PetsInitial extends PetsState {}

/// Loading state
class PetsLoading extends PetsState {}

/// Success state - all pets loaded
class PetsLoaded extends PetsState {
  final List<PetEntity> pets;
  final String selectedCategory;

  const PetsLoaded({
    required this.pets,
    this.selectedCategory = 'All',
  });

  @override
  List<Object?> get props => [pets, selectedCategory];

  PetsLoaded copyWith({
    List<PetEntity>? pets,
    String? selectedCategory,
  }) {
    return PetsLoaded(
      pets: pets ?? this.pets,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

/// Favorite pets loaded
class FavoritePetsLoaded extends PetsState {
  final List<PetEntity> favoritePets;

  const FavoritePetsLoaded(this.favoritePets);

  @override
  List<Object?> get props => [favoritePets];
}

/// Single pet loaded
class PetDetailsLoaded extends PetsState {
  final PetEntity pet;

  const PetDetailsLoaded(this.pet);

  @override
  List<Object?> get props => [pet];
}

/// Error state
class PetsError extends PetsState {
  final String message;

  const PetsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Favorite toggled successfully
class FavoriteToggled extends PetsState {
  final String petId;

  const FavoriteToggled(this.petId);

  @override
  List<Object?> get props => [petId];
}
