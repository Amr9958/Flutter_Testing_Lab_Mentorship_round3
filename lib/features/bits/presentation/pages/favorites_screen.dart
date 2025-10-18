import 'package:animals_store/core/constant/app_colors.dart';
import 'package:animals_store/core/di/injection_container.dart';
import 'package:animals_store/features/bits/presentation/cubit/pets_cubit.dart';
import 'package:animals_store/features/bits/presentation/cubit/pets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/pet_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PetsCubit>()..loadFavoritePets(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'My Favorite Pets',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<PetsCubit, PetsState>(
          builder: (context, state) {
            if (state is PetsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PetsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PetsCubit>().loadFavoritePets();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is FavoritePetsLoaded) {
              final favoritePets = state.favoritePets;

              if (favoritePets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 100,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoritePets.length,
                itemBuilder: (context, index) {
                  final pet = favoritePets[index];
                  return PetCard(
                    pet: pet,
                    onFavoriteToggle: () {
                      context.read<PetsCubit>().togglePetFavorite(pet.id);
                      // Reload favorites after toggle
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (context.mounted) {
                          context.read<PetsCubit>().loadFavoritePets();
                        }
                      });
                    },
                  );
                },
              );
            }

            return const Center(child: Text('No data'));
          },
        ),
      ),
    );
  }
}