import 'package:get_it/get_it.dart';
import 'package:animals_store/core/network/dio_client.dart';
import 'package:animals_store/core/network/network_info.dart';

// Dog API Feature
import 'package:animals_store/features/bits/data/datasources/dog_remote_data_source.dart';
import 'package:animals_store/features/bits/data/repositories/dog_repository_impl.dart';
import 'package:animals_store/features/bits/domain/repositories/dog_repository.dart';
import 'package:animals_store/features/bits/domain/usecases/get_dog_breeds.dart';
import 'package:animals_store/features/bits/domain/usecases/get_dog_images.dart';
import 'package:animals_store/features/bits/domain/usecases/get_dog_sources.dart';
import 'package:animals_store/features/bits/domain/usecases/search_dog_breeds.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_cubit.dart';

// Pet Feature (Local)
import 'package:animals_store/features/bits/data/datasources/pet_data_source.dart';
import 'package:animals_store/features/bits/data/repositories/pet_repository_impl.dart';
import 'package:animals_store/features/bits/domain/repositories/pet_repository.dart';
import 'package:animals_store/features/bits/domain/usecases/get_all_pets.dart';
import 'package:animals_store/features/bits/domain/usecases/get_favorite_pets.dart';
import 'package:animals_store/features/bits/domain/usecases/get_pet_by_id.dart';
import 'package:animals_store/features/bits/domain/usecases/get_pets_by_category.dart';
import 'package:animals_store/features/bits/domain/usecases/toggle_favorite.dart';
import 'package:animals_store/features/bits/presentation/cubit/pets_cubit.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ==================== Core ====================

  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // ==================== Features - Dog API ====================

  // Data sources
  sl.registerLazySingleton<DogRemoteDataSource>(
    () => DogRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<DogRepository>(
    () => DogRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDogBreeds(sl()));
  sl.registerLazySingleton(() => GetDogImages(sl()));
  sl.registerLazySingleton(() => GetDogSources(sl()));
  sl.registerLazySingleton(() => SearchDogBreeds(sl()));

  // Cubit
  sl.registerFactory(
    () => DogCubit(
      getDogBreeds: sl(),
      getDogImages: sl(),
      getDogSources: sl(),
      searchDogBreeds: sl(),
    ),
  );

  // ==================== Features - Pets (Local) ====================

  // Data sources
  sl.registerLazySingleton<PetDataSource>(
    () => PetDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllPets(sl()));
  sl.registerLazySingleton(() => GetFavoritePets(sl()));
  sl.registerLazySingleton(() => GetPetById(sl()));
  sl.registerLazySingleton(() => GetPetsByCategory(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // Cubit
  sl.registerFactory(
    () => PetsCubit(
      getAllPets: sl(),
      getFavoritePets: sl(),
      getPetById: sl(),
      getPetsByCategory: sl(),
      toggleFavorite: sl(),
    ),
  );
}
