import 'package:bloc/bloc.dart';
import 'package:animals_store/core/utils/logger.dart';
import 'package:animals_store/features/bits/domain/usecases/get_dog_breeds.dart';
import 'package:animals_store/features/bits/domain/usecases/get_dog_images.dart';
import 'package:animals_store/features/bits/domain/usecases/get_dog_sources.dart';
import 'package:animals_store/features/bits/domain/usecases/search_dog_breeds.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_state.dart';

/// Cubit for managing dog-related state
class DogCubit extends Cubit<DogState> {
  final GetDogBreeds getDogBreeds;
  final GetDogImages getDogImages;
  final GetDogSources getDogSources;
  final SearchDogBreeds searchDogBreeds;

  DogCubit({
    required this.getDogBreeds,
    required this.getDogImages,
    required this.getDogSources,
    required this.searchDogBreeds,
  }) : super(DogInitial());

  /// Load all dog breeds
  Future<void> loadBreeds({int limit = 10, int page = 0}) async {
    emit(DogLoading());

    final result = await getDogBreeds(
      GetDogBreedsParams(limit: limit, page: page),
    );

    result.fold(
      (failure) {
        Logger.logError('Failed to load breeds: ${failure.message}');
        emit(DogError(failure.message));
      },
      (breeds) {
        Logger.logSuccess('Loaded ${breeds.length} breeds');
        emit(BreedsLoaded(breeds));
      },
    );
  }

  /// Load dog images
  Future<void> loadDogImages({
    int limit = 10,
    int page = 0,
    String? breedId,
    String? size,
    bool hasBreeds = true,
  }) async {
    emit(DogLoading());

    final result = await getDogImages(
      GetDogImagesParams(
        limit: limit,
        page: page,
        breedId: breedId,
        size: size,
        hasBreeds: hasBreeds,
      ),
    );

    result.fold(
      (failure) {
        Logger.logError('Failed to load dog images: ${failure.message}');
        emit(DogError(failure.message));
      },
      (images) {
        Logger.logSuccess('Loaded ${images.length} dog images');
        emit(DogImagesLoaded(images));
      },
    );
  }

  /// Load sources
  Future<void> loadSources({int limit = 10, int page = 0}) async {
    emit(DogLoading());

    final result = await getDogSources(
      GetDogSourcesParams(limit: limit, page: page),
    );

    result.fold(
      (failure) {
        Logger.logError('Failed to load sources: ${failure.message}');
        emit(DogError(failure.message));
      },
      (sources) {
        Logger.logSuccess('Loaded ${sources.length} sources');
        emit(SourcesLoaded(sources));
      },
    );
  }

  /// Search breeds by name
  Future<void> searchBreeds(String query) async {
    if (query.isEmpty) {
      loadBreeds();
      return;
    }

    emit(DogLoading());

    final result = await searchDogBreeds(query);

    result.fold(
      (failure) {
        Logger.logError('Failed to search breeds: ${failure.message}');
        emit(DogError(failure.message));
      },
      (breeds) {
        Logger.logSuccess('Found ${breeds.length} breeds matching "$query"');
        emit(BreedsLoaded(breeds));
      },
    );
  }
}
