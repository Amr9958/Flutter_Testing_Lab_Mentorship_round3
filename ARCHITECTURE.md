# Animals Store - Clean Architecture Documentation

## Project Structure

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                          # Core functionality shared across features
│   ├── di/                        # Dependency Injection
│   │   └── injection_container.dart
│   ├── error/                     # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   ├── failures.dart          # Failure classes
│   │   └── error_messages.dart    # Centralized error messages
│   ├── network/                   # Network layer
│   │   ├── api_constants.dart     # API endpoints and constants
│   │   ├── dio_client.dart        # Dio HTTP client wrapper
│   │   ├── dio_interceptor.dart   # Request/Response interceptors
│   │   └── network_info.dart      # Network connectivity checker
│   ├── routes/                    # Navigation
│   │   ├── app_routes.dart        # Route names
│   │   └── app_router.dart        # Route generator
│   ├── usecase/                   # Base use case pattern
│   │   └── usecase.dart
│   ├── utils/                     # Utilities
│   │   ├── extensions.dart        # Extension methods
│   │   └── logger.dart            # Logging utility
│   └── constant/                  # Constants
│       └── app_colors.dart
│
├── features/                      # Feature modules
│   ├── bits/                      # Pets feature (rename to pets recommended)
│   │   ├── data/                  # Data layer
│   │   │   ├── datasources/       # Data sources (API, local DB)
│   │   │   │   └── pet_data_source.dart
│   │   │   ├── models/            # Data models (with JSON serialization)
│   │   │   │   └── pet_model.dart
│   │   │   └── repositories/      # Repository implementations
│   │   │       └── pet_repository_impl.dart
│   │   ├── domain/                # Domain layer (Business logic)
│   │   │   ├── entities/          # Business entities
│   │   │   │   └── pet_entity.dart
│   │   │   ├── repositories/      # Repository interfaces
│   │   │   │   └── pet_repository.dart
│   │   │   └── usecases/          # Use cases
│   │   │       ├── get_all_pets.dart
│   │   │       ├── get_favorite_pets.dart
│   │   │       ├── get_pet_by_id.dart
│   │   │       ├── get_pets_by_category.dart
│   │   │       └── toggle_favorite.dart
│   │   └── presentation/          # Presentation layer (UI)
│   │       ├── cubit/             # State management (Cubit)
│   │       │   ├── pets_cubit.dart
│   │       │   └── pets_state.dart
│   │       ├── pages/             # Screen pages
│   │       │   ├── home_screen.dart
│   │       │   ├── details_screen.dart
│   │       │   └── favorites_screen.dart
│   │       └── widgets/           # Reusable widgets
│   │           ├── pet_card.dart
│   │           └── category_chip.dart
│   └── app/                       # App-wide features
│       └── presentation/
│           └── pages/
│               └── on_pording.dart
│
└── main.dart                      # App entry point
```

---

## Architecture Layers

### 1. **Core Layer** (`lib/core/`)

Contains shared functionality used across all features:

#### Error Handling
- **Failures**: Domain-level errors (`ServerFailure`, `NetworkFailure`, etc.)
- **Exceptions**: Data-level exceptions (`ServerException`, `CacheException`, etc.)
- **Error Messages**: Centralized error message constants

#### Network
- **DioClient**: HTTP client wrapper with error handling
- **DioInterceptor**: Request/response/error interceptors
- **API Constants**: Base URLs, endpoints, timeout configurations
- **Network Info**: Check internet connectivity

#### Routing
- **AppRoutes**: Route name constants
- **AppRouter**: Navigation logic and route generation

#### Dependency Injection
- **GetIt**: Service locator for dependency injection
- All dependencies registered in `injection_container.dart`

#### Utils
- **Logger**: Debug logging utility
- **Extensions**: Helpful extension methods for String, BuildContext, DateTime

---

### 2. **Feature Layer** (`lib/features/`)

Each feature follows Clean Architecture with 3 sub-layers:

#### A. Data Layer (`data/`)
- **Data Sources**: API calls, local database, cache
- **Models**: Data models with JSON serialization (`fromJson`, `toJson`)
- **Repository Implementation**: Implements domain repository interfaces

**Responsibilities:**
- Fetch data from external sources (API, DB)
- Convert between models and entities
- Handle data-level exceptions
- Return `Either<Failure, Data>` to domain layer

#### B. Domain Layer (`domain/`)
- **Entities**: Pure business objects (no external dependencies)
- **Repository Interfaces**: Define data contracts
- **Use Cases**: Business logic operations

**Responsibilities:**
- Define business rules and logic
- Pure Dart (no Flutter dependencies)
- Independent of UI and data sources

#### C. Presentation Layer (`presentation/`)
- **Cubit/Bloc**: State management
- **States**: UI states (Loading, Success, Error)
- **Pages**: Screen widgets
- **Widgets**: Reusable UI components

**Responsibilities:**
- Display UI
- Handle user interactions
- Manage UI state
- Call use cases via dependency injection

---

## Data Flow

```
UI (Widget)
    ↓
Cubit/Bloc
    ↓
Use Case (Domain)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
Data Source (API/Cache)
    ↓
External Source (Server/DB)
```

**Return Flow:**
```
External Source → Data Source → Repository → Use Case → Cubit → UI
```

---

## Error Handling

### Two-Level Error System

1. **Exceptions** (Data Layer)
   - Thrown when data operations fail
   - Types: `ServerException`, `NetworkException`, `CacheException`

2. **Failures** (Domain Layer)
   - Returned via `Either<Failure, Data>`
   - Types: `ServerFailure`, `NetworkFailure`, `CacheFailure`

### Flow:
```dart
// Data Layer throws exceptions
throw ServerException(message: 'API failed');

// Repository converts to failures
return Left(ServerFailure('API failed'));

// Use Case returns Either
Either<Failure, List<Pet>> result = await useCase();

// Cubit handles result
result.fold(
  (failure) => emit(Error(failure.message)),
  (data) => emit(Success(data)),
);
```

---

## State Management (Cubit)

Using **flutter_bloc** for state management:

```dart
// States
PetsInitial()
PetsLoading()
PetsLoaded(pets)
PetsError(message)

// Cubit
class PetsCubit extends Cubit<PetsState> {
  final GetAllPets useCase;

  Future<void> loadPets() async {
    emit(PetsLoading());
    final result = await useCase();
    result.fold(
      (failure) => emit(PetsError(failure.message)),
      (pets) => emit(PetsLoaded(pets)),
    );
  }
}
```

---

## Dependency Injection

Using **GetIt** for dependency injection:

```dart
// Register dependencies
sl.registerLazySingleton<DioClient>(() => DioClient());
sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl()));
sl.registerLazySingleton(() => GetAllPets(sl()));
sl.registerFactory(() => PetsCubit(getAllPets: sl()));

// Use in widget
BlocProvider(
  create: (_) => sl<PetsCubit>()..loadPets(),
  child: HomeScreen(),
)
```

---

## Key Packages

- **dio**: HTTP client
- **dartz**: Functional programming (Either, Option)
- **get_it**: Dependency injection
- **flutter_bloc**: State management
- **equatable**: Value equality

---

## API Integration

### Current Setup:
- Using local dummy data in `PetDataSourceImpl`
- Ready for API integration

### To Integrate Real API:

1. Update `ApiConstants.baseUrl` in `lib/core/network/api_constants.dart`
2. Implement API calls in data source:

```dart
class PetDataSourceImpl implements PetDataSource {
  final DioClient client;

  @override
  Future<List<PetModel>> getAllPets() async {
    final response = await client.get(ApiConstants.pets);
    return (response.data as List)
      .map((json) => PetModel.fromJson(json))
      .toList();
  }
}
```

3. Update dependency injection to inject `DioClient`

---

## Best Practices

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Rule**: Dependencies point inward (UI → Domain ← Data)
3. **Testability**: Pure business logic in domain layer
4. **Error Handling**: Consistent error handling with Either pattern
5. **DI**: All dependencies injected, not created
6. **Immutability**: Use immutable entities and models

---

## Next Steps

- [ ] Add unit tests for use cases
- [ ] Add widget tests for UI
- [ ] Integrate real API
- [ ] Add local caching (Hive/SharedPreferences)
- [ ] Add connectivity checking
- [ ] Add authentication feature
- [ ] Add internationalization (i18n)

---

## File Naming Conventions

- **Entities**: `entity_name.dart` (e.g., `pet_entity.dart`)
- **Models**: `model_name.dart` (e.g., `pet_model.dart`)
- **Use Cases**: `verb_noun.dart` (e.g., `get_all_pets.dart`)
- **Repositories**: `repository_name.dart` (e.g., `pet_repository.dart`)
- **Cubits**: `feature_cubit.dart` (e.g., `pets_cubit.dart`)
- **States**: `feature_state.dart` (e.g., `pets_state.dart`)

---

## Questions?

For questions or issues, please refer to:
- Clean Architecture: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- Flutter Bloc: https://bloclibrary.dev/
