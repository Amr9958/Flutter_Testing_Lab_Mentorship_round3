import 'package:animals_store/core/constant/app_colors.dart';
import 'package:animals_store/core/di/injection_container.dart';
import 'package:animals_store/core/routes/app_routes.dart';
import 'package:animals_store/features/bits/presentation/cubit/pets_cubit.dart';
import 'package:animals_store/features/bits/presentation/cubit/pets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/category_chip.dart';
import '../widgets/pet_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PetsCubit>()..loadAllPets(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Dog', 'Cat', 'Bird'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cairo, Egypt',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.favorites);
                },
                icon: const Icon(Icons.favorite_border),
                color: AppColors.textDark,
              ),
              // Dog API Buttons
              PopupMenuButton<String>(
                icon: Icon(Icons.pets, color: AppColors.textDark),
                onSelected: (value) {
                  if (value == 'breeds') {
                    Navigator.pushNamed(context, AppRoutes.dogBreeds);
                  } else if (value == 'images') {
                    Navigator.pushNamed(context, AppRoutes.dogImages);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'breeds',
                    child: Row(
                      children: [
                        Icon(Icons.list),
                        SizedBox(width: 8),
                        Text('Dog Breeds'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'images',
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        SizedBox(width: 8),
                        Text('Dog Images'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search pets...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: _categories[index],
                    isSelected: _selectedCategory == _categories[index],
                    onTap: () {
                      setState(() {
                        _selectedCategory = _categories[index];
                      });
                      context.read<PetsCubit>().loadPetsByCategory(_selectedCategory);
                    },
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Pets List with BlocBuilder
          BlocBuilder<PetsCubit, PetsState>(
            builder: (context, state) {
              if (state is PetsLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is PetsError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PetsCubit>().loadAllPets();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is PetsLoaded) {
                final pets = state.pets;

                if (pets.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No pets found')),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pet = pets[index];
                        return PetCard(
                          pet: pet,
                          onFavoriteToggle: () {
                            context.read<PetsCubit>().togglePetFavorite(pet.id);
                          },
                        );
                      },
                      childCount: pets.length,
                    ),
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(child: Text('No data')),
              );
            },
          ),
        ],
      ),
    );
  }
}
