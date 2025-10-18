# Dog API Integration Guide

## Overview

This project is now integrated with **The Dog API** - a free, open API that provides access to thousands of dog images and breed information.

## Setup Instructions

### 1. Get Your API Key

1. Visit [https://thedogapi.com](https://thedogapi.com)
2. Sign up for a free API key
3. Copy your API key

### 2. Configure API Key

Open `lib/core/network/api_constants.dart` and replace the placeholder with your actual API key:

```dart
// API Key - Replace with your actual API key from https://thedogapi.com
static const String apiKey = 'YOUR_API_KEY_HERE'; // ← Replace this
```

### 3. Run the App

```bash
flutter pub get
flutter run
```

---

## Available Features

### 1. Get Dog Breeds

Fetch a list of all dog breeds with detailed information.

**Usage:**
```dart
// In your widget
BlocProvider(
  create: (_) => sl<DogCubit>()..loadBreeds(limit: 20, page: 0),
  child: BlocBuilder<DogCubit, DogState>(
    builder: (context, state) {
      if (state is BreedsLoaded) {
        return ListView.builder(
          itemCount: state.breeds.length,
          itemBuilder: (context, index) {
            final breed = state.breeds[index];
            return ListTile(
              title: Text(breed.name),
              subtitle: Text(breed.temperament ?? ''),
            );
          },
        );
      }
      // Handle other states...
    },
  ),
)
```

**Breed Entity Fields:**
- `id`: Breed identifier
- `name`: Breed name
- `breedGroup`: Breed group (e.g., "Sporting", "Working")
- `bredFor`: Purpose the breed was bred for
- `temperament`: Personality traits
- `lifeSpan`: Average lifespan
- `origin`: Country of origin
- `weight`: Weight range in kg
- `height`: Height range in cm
- `imageUrl`: Breed image URL

---

### 2. Get Dog Images

Fetch random dog images with optional filters.

**Usage:**
```dart
// Get random dog images with breed info
context.read<DogCubit>().loadDogImages(
  limit: 10,
  hasBreeds: true, // Include breed information
);

// Get images for a specific breed
context.read<DogCubit>().loadDogImages(
  limit: 10,
  breedId: '1', // Specific breed ID
  hasBreeds: true,
);
```

**Dog Image Entity Fields:**
- `id`: Image identifier
- `url`: Full image URL
- `width`: Image width in pixels
- `height`: Image height in pixels
- `breeds`: List of breed information (if hasBreeds = true)

---

### 3. Search Breeds

Search for dog breeds by name.

**Usage:**
```dart
// Search for breeds containing "retriever"
context.read<DogCubit>().searchBreeds('retriever');
```

---

### 4. Get Sources

Fetch information sources about dogs.

**Usage:**
```dart
context.read<DogCubit>().loadSources(limit: 10, page: 0);
```

**Source Entity Fields:**
- `id`: Source identifier
- `name`: Source name (e.g., "Wikipedia", "VCA Hospitals")
- `url`: Source website URL
- `breedId`: Associated breed ID (if applicable)

---

## API Endpoints

The following Dog API endpoints are configured:

| Endpoint | Description | Parameters |
|----------|-------------|------------|
| `GET /v1/breeds` | Get all breeds | `limit`, `page` |
| `GET /v1/images/search` | Search images | `limit`, `page`, `breed_id`, `size`, `has_breeds` |
| `GET /v1/images/{id}` | Get image by ID | `id` |
| `GET /v1/sources` | Get sources | `limit`, `page` |
| `GET /v1/breeds/search` | Search breeds | `q` (query) |

---

## Architecture

### Data Flow

```
UI Widget
    ↓
DogCubit (Presentation)
    ↓
Use Cases (Domain)
    ├── GetDogBreeds
    ├── GetDogImages
    ├── GetDogSources
    └── SearchDogBreeds
    ↓
DogRepository (Domain Interface)
    ↓
DogRepositoryImpl (Data)
    ↓
DogRemoteDataSource (Data)
    ↓
DioClient (Core Network)
    ↓
Dog API (https://api.thedogapi.com)
```

### File Structure

```
lib/
├── core/
│   └── network/
│       ├── api_constants.dart        # Dog API configuration
│       ├── dio_client.dart           # HTTP client
│       └── dio_interceptor.dart      # Request/response handling
│
├── features/bits/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── dog_remote_data_source.dart  # API calls
│   │   ├── models/
│   │   │   ├── breed_model.dart            # JSON serialization
│   │   │   ├── dog_image_model.dart
│   │   │   └── source_model.dart
│   │   └── repositories/
│   │       └── dog_repository_impl.dart     # Repository implementation
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── breed_entity.dart           # Business models
│   │   │   ├── dog_image_entity.dart
│   │   │   └── source_entity.dart
│   │   ├── repositories/
│   │   │   └── dog_repository.dart          # Repository interface
│   │   └── usecases/
│   │       ├── get_dog_breeds.dart         # Business logic
│   │       ├── get_dog_images.dart
│   │       ├── get_dog_sources.dart
│   │       └── search_dog_breeds.dart
│   │
│   └── presentation/
│       └── cubit/
│           ├── dog_cubit.dart              # State management
│           └── dog_state.dart              # UI states
```

---

## State Management

### States

The `DogCubit` emits the following states:

```dart
DogInitial()          // Initial state
DogLoading()          // Loading data
BreedsLoaded(breeds)  // Breeds loaded successfully
DogImagesLoaded(images) // Images loaded successfully
SourcesLoaded(sources)  // Sources loaded successfully
DogError(message)     // Error occurred
```

### Example Usage

```dart
BlocBuilder<DogCubit, DogState>(
  builder: (context, state) {
    if (state is DogLoading) {
      return CircularProgressIndicator();
    }

    if (state is BreedsLoaded) {
      return BreedsList(breeds: state.breeds);
    }

    if (state is DogImagesLoaded) {
      return ImagesGrid(images: state.images);
    }

    if (state is DogError) {
      return ErrorWidget(message: state.message);
    }

    return SizedBox.shrink();
  },
)
```

---

## Error Handling

All API calls are wrapped with proper error handling:

- **Network Errors**: No internet connection
- **Server Errors**: API server issues (500, 502, 503)
- **Client Errors**: Bad requests (400, 404)
- **Auth Errors**: Invalid API key (401, 403)
- **Unexpected Errors**: Unknown errors

Errors are converted to user-friendly messages and emitted as `DogError` state.

---

## Dependency Injection

All dependencies are registered in `lib/core/di/injection_container.dart`:

```dart
// Data Source
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

// Use Cases
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
```

---

## Example: Complete Feature Implementation

Here's a complete example of a screen that displays dog breeds:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_store/core/di/injection_container.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_cubit.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_state.dart';

class DogBreedsScreen extends StatelessWidget {
  const DogBreedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dog Breeds')),
      body: BlocProvider(
        create: (_) => sl<DogCubit>()..loadBreeds(limit: 50),
        child: BlocBuilder<DogCubit, DogState>(
          builder: (context, state) {
            if (state is DogLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is BreedsLoaded) {
              return ListView.builder(
                itemCount: state.breeds.length,
                itemBuilder: (context, index) {
                  final breed = state.breeds[index];
                  return Card(
                    child: ListTile(
                      leading: breed.imageUrl != null
                          ? Image.network(breed.imageUrl!, width: 60)
                          : Icon(Icons.pets),
                      title: Text(breed.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (breed.breedGroup != null)
                            Text('Group: ${breed.breedGroup}'),
                          if (breed.temperament != null)
                            Text(breed.temperament!),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is DogError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(state.message),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<DogCubit>().loadBreeds(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

---

## Testing

To test the API integration:

1. Add your API key to `api_constants.dart`
2. Run the app
3. Navigate to a screen that uses `DogCubit`
4. Check the console for API logs (enabled in DioInterceptor)

### Sample Test Call

```dart
// In your initState or button press
context.read<DogCubit>().loadBreeds(limit: 5, page: 0);

// Expected console output:
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// REQUEST
// GET https://api.thedogapi.com/v1/breeds?limit=5&page=0
// Headers: {x-api-key: YOUR_API_KEY, ...}
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// RESPONSE
// Status: 200
// Data: [{id: 1, name: Affenpinscher, ...}, ...]
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## API Limits

- Free tier: No strict limits mentioned
- Rate limiting: Be respectful, don't spam requests
- Recommended: Cache images locally for better performance

---

## Next Steps

1. **Add your API key** to `api_constants.dart`
2. **Create UI screens** to display breeds and images
3. **Implement caching** for offline support
4. **Add favorites** feature with local storage
5. **Implement search** functionality
6. **Add image galleries** with pagination

---

## Resources

- Dog API Documentation: https://docs.thedogapi.com
- API Console: https://thedogapi.com
- Get API Key: https://thedogapi.com (free signup)

---

## Troubleshooting

### API Key Not Working
- Make sure you copied the correct API key
- Check that the key is set in `api_constants.dart`
- Verify the key in DioClient headers

### No Data Returned
- Check your internet connection
- Verify API key is valid
- Check console logs for error details

### Images Not Loading
- Verify image URLs are valid
- Check CORS settings in web builds
- Use `cached_network_image` package for better performance

---

**Happy Coding! 🐕**
