import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_store/core/di/injection_container.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_cubit.dart';
import 'package:animals_store/features/bits/presentation/cubit/dog_state.dart';

/// Screen to display random dog images from The Dog API
class DogImagesScreen extends StatelessWidget {
  const DogImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Images'),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DogCubit>().loadDogImages(
                    limit: 20,
                    hasBreeds: true,
                  );
            },
            tooltip: 'Load new images',
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => sl<DogCubit>()
          ..loadDogImages(
            limit: 20,
            hasBreeds: true,
          ),
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
                    Text('Loading dog images...'),
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
                          context.read<DogCubit>().loadDogImages(
                                limit: 20,
                                hasBreeds: true,
                              );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Success state - images loaded
            if (state is DogImagesLoaded) {
              final images = state.images;

              if (images.isEmpty) {
                return const Center(
                  child: Text('No images found'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DogCubit>().loadDogImages(
                        limit: 20,
                        hasBreeds: true,
                      );
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final image = images[index];
                    final hasBreeds =
                        image.breeds != null && image.breeds!.isNotEmpty;

                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          // Show image in full screen or details
                          _showImageDialog(context, image.url);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Image
                            Expanded(
                              child: Image.network(
                                image.url,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Breed info (if available)
                            if (hasBreeds)
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.brown[100],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      image.breeds!.first.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (image.breeds!.first.breedGroup != null)
                                      Text(
                                        image.breeds!.first.breedGroup!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                          ],
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
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Dog Image'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Flexible(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
