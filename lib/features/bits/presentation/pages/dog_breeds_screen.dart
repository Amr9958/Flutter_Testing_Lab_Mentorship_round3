import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_store/core/di/injection_container.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_cubit.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_state.dart';

/// Screen to display dog breeds from The Dog API
class DogBreedsScreen extends StatelessWidget {
  const DogBreedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Breeds'),
        backgroundColor: Colors.brown,
      ),
      body: BlocProvider(
        create: (_) => sl<DogCubit>()..loadBreeds(limit: 50, page: 0),
        child: BlocBuilder<DogCubit, DogState>(
          builder: (context, state) {
            // Loading state
            if (state is DogLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading dog breeds...'),
                  ],
                ),
              );
            }

            // Error state
            if (state is DogError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<DogCubit>().loadBreeds(limit: 50);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Success state - breeds loaded
            if (state is BreedsLoaded) {
              final breeds = state.breeds;

              if (breeds.isEmpty) {
                return const Center(
                  child: Text('No breeds found'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DogCubit>().loadBreeds(limit: 50);
                },
                child: ListView.builder(
                  itemCount: breeds.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final breed = breeds[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigate to breed details screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tapped on ${breed.name}'),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Breed image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: breed.imageUrl != null
                                    ? Image.network(
                                        breed.imageUrl!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.pets,
                                              size: 40,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.pets,
                                          size: 40,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),

                              // Breed info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Breed name
                                    Text(
                                      breed.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    // Breed group
                                    if (breed.breedGroup != null)
                                      Text(
                                        breed.breedGroup!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),

                                    // Bred for
                                    if (breed.bredFor != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Bred for: ${breed.bredFor}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),

                                    // Temperament
                                    if (breed.temperament != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          breed.temperament!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),

                                    // Life span
                                    if (breed.lifeSpan != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              breed.lifeSpan!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Arrow icon
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            // Default/Initial state
            return const Center(
              child: Text('Pull to refresh'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add search functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Search functionality coming soon!'),
            ),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
