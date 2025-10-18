import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Unit Tests', () {
    group('Email Validation Tests', () {
      test('should reject email without @', () {
        expect(ValidationHelper.isValidEmail('invalidemail'), false);
      });

      test('should reject email with only @ symbol', () {
        expect(ValidationHelper.isValidEmail('a@'), false);
      });

      test('should reject email without domain', () {
        expect(ValidationHelper.isValidEmail('@domain'), false);
      });

      test('should reject email without username', () {
        expect(ValidationHelper.isValidEmail('@domain.com'), false);
      });

      test('should reject email without TLD', () {
        expect(ValidationHelper.isValidEmail('user@domain'), false);
      });

      test('should accept valid email', () {
        expect(ValidationHelper.isValidEmail('user@domain.com'), true);
      });

      test('should accept valid email with subdomain', () {
        expect(ValidationHelper.isValidEmail('user@mail.domain.com'), true);
      });

      test('should accept valid email with plus sign', () {
        expect(ValidationHelper.isValidEmail('user+tag@domain.com'), true);
      });

      test('should accept valid email with numbers', () {
        expect(ValidationHelper.isValidEmail('user123@domain456.com'), true);
      });
    });

    group('Password Validation Tests', () {
      test('should reject empty password', () {
        expect(ValidationHelper.isValidPassword(''), false);
      });

      test('should reject password shorter than 8 characters', () {
        expect(ValidationHelper.isValidPassword('Pass1!'), false);
      });

      test('should reject password without numbers', () {
        expect(ValidationHelper.isValidPassword('Password!'), false);
      });

      test('should reject password without special characters', () {
        expect(ValidationHelper.isValidPassword('Password1'), false);
      });

      test('should reject password with only letters', () {
        expect(ValidationHelper.isValidPassword('password'), false);
      });

      test('should accept valid password with all requirements', () {
        expect(ValidationHelper.isValidPassword('Password1!'), true);
      });

      test('should accept password with multiple special characters', () {
        expect(ValidationHelper.isValidPassword('P@ssw0rd!'), true);
      });

      test('should accept strong password', () {
        expect(ValidationHelper.isValidPassword('MyP@ssw0rd123'), true);
      });
    });
  });

  group('UserRegistrationForm Widget Tests', () {
    testWidgets('should display all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should show error for empty name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('should show error for short name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'A',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalid@',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for weak password', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'weak',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password1!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'DifferentPass1!',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should submit successfully with valid data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password1!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password1!',
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Registration successful!'), findsOneWidget);
    });

    testWidgets('should not submit with invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'a@',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password1!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password1!',
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Should show validation error instead of submitting
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Registration successful!'), findsNothing);
    });

    testWidgets('should not submit with weak password', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserRegistrationForm(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'weak',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'weak',
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Should show validation error instead of submitting
      expect(find.text('Password is too weak'), findsOneWidget);
      expect(find.text('Registration successful!'), findsNothing);
    });
  });
}
