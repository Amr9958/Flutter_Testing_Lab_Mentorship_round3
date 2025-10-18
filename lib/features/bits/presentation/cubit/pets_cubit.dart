import 'package:bloc/bloc.dart';
import 'package:animals_store/core/utils/logger.dart';
import 'package:animals_store/features/bits/domain/usecases/get_all_pets.dart';
import 'package:animals_store/features/bits/domain/usecases/get_favorite_pets.dart';
import 'package:animals_store/features/bits/domain/usecases/get_pet_by_id.dart';
import 'package:animals_store/features/bits/domain/usecases/get_pets_by_category.dart';
import 'package:animals_store/features/bits/domain/usecases/toggle_favorite.dart';
import 'package:animals_store/features/bits/presentation/cubit/pets_state.dart';

/// Cubit for managing pets state
class PetsCubit extends Cubit<PetsState> {
  final GetAllPets getAllPets;
  final GetFavoritePets getFavoritePets;
  final GetPetById getPetById;
  final GetPetsByCategory getPetsByCategory;
  final ToggleFavorite toggleFavorite;

  PetsCubit({
    required this.getAllPets,
    required this.getFavoritePets,
    required this.getPetById,
    required this.getPetsByCategory,
    required this.toggleFavorite,
  }) : super(PetsInitial());

  /// Load all pets
  Future<void> loadAllPets() async {
    emit(PetsLoading());

    final result = await getAllPets();

    result.fold(
      (failure) {
        Logger.logError('Failed to load pets: ${failure.message}');
        emit(PetsError(failure.message));
      },
      (pets) {
        Logger.logSuccess('Loaded ${pets.length} pets');
        emit(PetsLoaded(pets: pets));
      },
    );
  }

  /// Load pets by category
  Future<void> loadPetsByCategory(String category) async {
    emit(PetsLoading());

    final result = await getPetsByCategory(category);

    result.fold(
      (failure) {
        Logger.logError('Failed to load pets by category: ${failure.message}');
        emit(PetsError(failure.message));
      },
      (pets) {
        Logger.logSuccess('Loaded ${pets.length} pets for category: $category');
        emit(PetsLoaded(pets: pets, selectedCategory: category));
      },
    );
  }

  /// Load favorite pets
  Future<void> loadFavoritePets() async {
    emit(PetsLoading());

    final result = await getFavoritePets();

    result.fold(
      (failure) {
        Logger.logError('Failed to load favorite pets: ${failure.message}');
        emit(PetsError(failure.message));
      },
      (pets) {
        Logger.logSuccess('Loaded ${pets.length} favorite pets');
        emit(FavoritePetsLoaded(pets));
      },
    );
  }

  /// Load pet details by ID
  Future<void> loadPetById(String id) async {
    emit(PetsLoading());

    final result = await getPetById(id);

    result.fold(
      (failure) {
        Logger.logError('Failed to load pet details: ${failure.message}');
        emit(PetsError(failure.message));
      },
      (pet) {
        Logger.logSuccess('Loaded pet details: ${pet.name}');
        emit(PetDetailsLoaded(pet));
      },
    );
  }

  /// Toggle favorite status
  Future<void> togglePetFavorite(String id) async {
    final result = await toggleFavorite(id);

    result.fold(
      (failure) {
        Logger.logError('Failed to toggle favorite: ${failure.message}');
        emit(PetsError(failure.message));
      },
      (_) {
        Logger.logSuccess('Toggled favorite for pet: $id');
        // Reload pets to reflect changes
        loadAllPets();
      },
    );
  }

  /// Filter pets by category without API call
  void filterByCategory(String category) {
    if (state is PetsLoaded) {
      final currentState = state as PetsLoaded;
      emit(currentState.copyWith(selectedCategory: category));
    }
  }
}
