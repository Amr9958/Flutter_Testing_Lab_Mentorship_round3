import 'package:animals_store/core/di/injection_container.dart';
import 'package:animals_store/core/routes/app_router.dart';
import 'package:animals_store/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animals Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Use app router for navigation
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRoutes.onboarding,
    );
  }
}
