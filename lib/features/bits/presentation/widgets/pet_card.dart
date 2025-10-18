import 'package:animals_store/core/constant/app_colors.dart';
import 'package:animals_store/core/routes/app_routes.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';
import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onFavoriteToggle;

  const PetCard({
    super.key,
    required this.pet,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.petDetails,
          arguments: pet,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الحيوان مع Hero Animation
            Hero(
              tag: 'pet-${pet.id}',
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: pet.category == 'Dog'
                      ? AppColors.dogColor
                      : AppColors.catColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    pet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.pets,
                        size: 40,
                        color: AppColors.primary,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // معلومات الحيوان
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet.breed,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${pet.distance} km',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // زر المفضلة
            IconButton(
              onPressed: onFavoriteToggle,
              icon: Icon(
                pet.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: pet.isFavorite ? Colors.red : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}