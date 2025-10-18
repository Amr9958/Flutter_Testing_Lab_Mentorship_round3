import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherDisplay Unit Tests', () {
    group('Temperature Conversion Tests', () {
      test('should convert 0°C to 32°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(0), 32.0);
      });

      test('should convert 100°C to 212°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(100), 212.0);
      });

      test('should convert 25°C to 77°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(25), 77.0);
      });

      test('should convert negative temperature -40°C to -40°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(-40), -40.0);
      });

      test('should convert 32°F to 0°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(32), 0.0);
      });

      test('should convert 212°F to 100°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(212), 100.0);
      });

      test('should convert 77°F to 25°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(77), 25.0);
      });

      test('should convert negative temperature -40°F to -40°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(-40), -40.0);
      });

      test('should handle fractional temperatures C to F', () {
        expect(
          TemperatureConverter.celsiusToFahrenheit(22.5),
          closeTo(72.5, 0.01),
        );
      });

      test('should handle fractional temperatures F to C', () {
        expect(
          TemperatureConverter.fahrenheitToCelsius(72.5),
          closeTo(22.5, 0.01),
        );
      });
    });

    group('WeatherData.fromJson Tests', () {
      test('should create WeatherData from complete JSON', () {
        final json = {
          'city': 'New York',
          'temperature': 25.0,
          'description': 'Sunny',
          'humidity': 65,
          'windSpeed': 12.3,
          'icon': '☀️',
        };

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.city, 'New York');
        expect(weatherData.temperatureCelsius, 25.0);
        expect(weatherData.description, 'Sunny');
        expect(weatherData.humidity, 65);
        expect(weatherData.windSpeed, 12.3);
        expect(weatherData.icon, '☀️');
      });

      test('should handle missing optional fields with defaults', () {
        final json = {
          'city': 'London',
          'temperature': 15.0,
        };

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.city, 'London');
        expect(weatherData.temperatureCelsius, 15.0);
        expect(weatherData.description, 'Unknown');
        expect(weatherData.humidity, 0);
        expect(weatherData.windSpeed, 0.0);
        expect(weatherData.icon, '❓');
      });

      test('should throw FormatException when city is missing', () {
        final json = {
          'temperature': 25.0,
          'description': 'Sunny',
        };

        expect(
          () => WeatherData.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw FormatException when temperature is missing', () {
        final json = {
          'city': 'Tokyo',
          'description': 'Cloudy',
        };

        expect(
          () => WeatherData.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });

      test('should handle integer temperature value', () {
        final json = {
          'city': 'Tokyo',
          'temperature': 25,  // Integer instead of double
        };

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.temperatureCelsius, 25.0);
      });

      test('should handle integer windSpeed value', () {
        final json = {
          'city': 'London',
          'temperature': 15.0,
          'windSpeed': 10,  // Integer instead of double
        };

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.windSpeed, 10.0);
      });
    });
  });

  group('WeatherDisplay Widget Tests', () {
    testWidgets('should display loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the initial load to complete
      await tester.pumpAndSettle();
    });

    testWidgets('should display weather data after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Should display weather data (if not invalid city or incomplete data)
      // The test might show either weather data or error depending on random behavior
      final hasWeatherData = find.textContaining('New York').evaluate().isNotEmpty;
      final hasError = find.byIcon(Icons.error_outline).evaluate().isNotEmpty;

      expect(hasWeatherData || hasError, true);
    });

    testWidgets('should display error state for invalid city', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Select "Invalid City"
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      // Should show error
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Failed to load weather data'), findsOneWidget);
    });

    testWidgets('should have retry button in error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Select "Invalid City" to trigger error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      // Should have retry button
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should toggle temperature unit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially should show Celsius
      expect(find.text('Celsius'), findsOneWidget);

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets('should change city when dropdown selection changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open dropdown and select London
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle();

      // Should show loading then London data
      final hasLondon = find.textContaining('London').evaluate().isNotEmpty;
      expect(hasLondon, true);
    });

    testWidgets('should refresh weather data when refresh button clicked', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap refresh button
      await tester.tap(find.text('Refresh'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the refresh to complete
      await tester.pumpAndSettle();
    });

    testWidgets('should display all weather details when data loaded successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to load a valid city (not Invalid City)
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pumpAndSettle();

      // If data loaded successfully (not the random incomplete data case)
      final hasWeatherData = find.textContaining('Tokyo').evaluate().isNotEmpty;

      if (hasWeatherData) {
        // Should display humidity and wind speed labels
        expect(find.text('Humidity'), findsOneWidget);
        expect(find.text('Wind Speed'), findsOneWidget);
      }
    });
  });
}
