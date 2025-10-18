import 'package:flutter/material.dart';
import 'package:animals_store/core/routes/app_routes.dart';
import 'package:animals_store/features/app/presentation/pages/on_pording.dart';
import 'package:animals_store/features/bits/presentation/pages/home_screen.dart';
import 'package:animals_store/features/bits/presentation/pages/details_screen.dart';
import 'package:animals_store/features/bits/presentation/pages/favorites_screen.dart';
import 'package:animals_store/features/bits/presentation/pages/dog_breeds_screen.dart';
import 'package:animals_store/features/bits/presentation/pages/dog_images_screen.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';

/// App router for navigation management
class AppRouter {
  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.petDetails:
        final pet = settings.arguments as PetEntity?;
        if (pet == null) {
          return _errorRoute('Pet data is required');
        }
        return MaterialPageRoute(
          builder: (_) => DetailsScreen(pet: pet),
          settings: settings,
        );

      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
          settings: settings,
        );

      // Dog API routes
      case AppRoutes.dogBreeds:
        return MaterialPageRoute(
          builder: (_) => const DogBreedsScreen(),
          settings: settings,
        );

      case AppRoutes.dogImages:
        return MaterialPageRoute(
          builder: (_) => const DogImagesScreen(),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Error route for undefined routes
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }

  /// Navigate to a named route
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace current route
  static Future<T?> navigateAndReplace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, void>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove all previous routes
  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop current route
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}
