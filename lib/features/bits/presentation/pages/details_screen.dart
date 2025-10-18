import 'package:animals_store/core/constant/app_colors.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';

import 'package:flutter/material.dart';


class DetailsScreen extends StatelessWidget {
  final PetEntity pet;

  const DetailsScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
        
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'pet-${pet.id}',
                child: Container(
                  decoration: BoxDecoration(
                    color: pet.category == 'Dog'
                        ? AppColors.dogColor
                        : AppColors.catColor,
                  ),
                  child: Image.asset(
                    pet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.pets,
                          size: 100,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // معلومات الحيوان
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم والسعر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pet.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pet.breed,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // الموقع
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 18,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pet.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${pet.distance} km away',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // معلومات سريعة
                    Row(
                      children: [
                        _buildInfoCard('Age', '${pet.age} Years'),
                        const SizedBox(width: 12),
                        _buildInfoCard('Gender', pet.gender),
                        const SizedBox(width: 12),
                        _buildInfoCard('Weight', '${pet.weight} kg'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // عنوان الوصف
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // الوصف
                    Text(
                      pet.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textLight,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // زر Adopt
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Adopt action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Adoption request sent for ${pet.name}!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Adopt Me',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}