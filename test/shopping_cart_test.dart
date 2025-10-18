import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('ShoppingCart Unit Tests', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
    });

    group('Add Item Tests', () {
      test('should add new item to empty cart', () {
        cartManager.addItem('1', 'iPhone', 999.99);

        expect(cartManager.totalItems, 1);
        expect(cartManager.subtotal, 999.99);
      });

      test('should update quantity when adding duplicate item', () {
        cartManager.addItem('1', 'iPhone', 999.99);
        cartManager.addItem('1', 'iPhone', 999.99);

        // Should have only 1 unique item with quantity 2
        expect(cartManager.totalItems, 2);
        expect(cartManager.subtotal, 1999.98);
      });

      test('should add multiple different items', () {
        cartManager.addItem('1', 'iPhone', 999.99);
        cartManager.addItem('2', 'Galaxy', 899.99);
        cartManager.addItem('3', 'iPad', 1099.99);

        expect(cartManager.totalItems, 3);
        expect(cartManager.subtotal, closeTo(2999.97, 0.01));
      });

      test('should handle multiple additions of same item', () {
        cartManager.addItem('1', 'iPhone', 999.99);
        cartManager.addItem('1', 'iPhone', 999.99);
        cartManager.addItem('1', 'iPhone', 999.99);

        expect(cartManager.totalItems, 3);
        expect(cartManager.subtotal, closeTo(2999.97, 0.01));
      });
    });

    group('Remove Item Tests', () {
      test('should remove item from cart', () {
        cartManager.addItem('1', 'iPhone', 999.99);
        cartManager.addItem('2', 'Galaxy', 899.99);

        cartManager.removeItem('1');

        expect(cartManager.totalItems, 1);
        expect(cartManager.subtotal, 899.99);
      });

      test('should handle removing non-existent item', () {
        cartManager.addItem('1', 'iPhone', 999.99);

        cartManager.removeItem('999');

        expect(cartManager.totalItems, 1);
        expect(cartManager.subtotal, 999.99);
      });
    });

    group('Update Quantity Tests', () {
      test('should update item quantity', () {
        cartManager.addItem('1', 'iPhone', 999.99);

        cartManager.updateQuantity('1', 3);

        expect(cartManager.totalItems, 3);
        expect(cartManager.subtotal, closeTo(2999.97, 0.01));
      });

      test('should remove item when quantity set to 0', () {
        cartManager.addItem('1', 'iPhone', 999.99);

        cartManager.updateQuantity('1', 0);

        expect(cartManager.totalItems, 0);
        expect(cartManager.subtotal, 0);
      });

      test('should remove item when quantity set to negative', () {
        cartManager.addItem('1', 'iPhone', 999.99);

        cartManager.updateQuantity('1', -1);

        expect(cartManager.totalItems, 0);
        expect(cartManager.subtotal, 0);
      });
    });

    group('Clear Cart Tests', () {
      test('should clear all items from cart', () {
        cartManager.addItem('1', 'iPhone', 999.99);
        cartManager.addItem('2', 'Galaxy', 899.99);
        cartManager.addItem('3', 'iPad', 1099.99);

        cartManager.clearCart();

        expect(cartManager.totalItems, 0);
        expect(cartManager.subtotal, 0);
      });
    });

    group('Discount Calculation Tests', () {
      test('should calculate discount correctly for single item', () {
        cartManager.addItem('1', 'iPhone', 1000.0, discount: 0.1);

        // 10% discount on $1000 = $100
        expect(cartManager.totalDiscount, closeTo(100.0, 0.01));
        expect(cartManager.totalAmount, closeTo(900.0, 0.01));
      });

      test('should calculate discount for multiple quantities', () {
        cartManager.addItem('1', 'iPhone', 1000.0, discount: 0.1);
        cartManager.addItem('1', 'iPhone', 1000.0, discount: 0.1);

        // 10% discount on $2000 = $200
        expect(cartManager.totalDiscount, closeTo(200.0, 0.01));
        expect(cartManager.totalAmount, closeTo(1800.0, 0.01));
      });

      test('should calculate discount for multiple items with different discounts', () {
        cartManager.addItem('1', 'iPhone', 1000.0, discount: 0.1);  // $100 discount
        cartManager.addItem('2', 'Galaxy', 900.0, discount: 0.15);  // $135 discount

        expect(cartManager.totalDiscount, closeTo(235.0, 0.01));
        expect(cartManager.totalAmount, closeTo(1665.0, 0.01));
      });

      test('should handle 100% discount', () {
        cartManager.addItem('1', 'iPhone', 1000.0, discount: 1.0);

        expect(cartManager.totalDiscount, closeTo(1000.0, 0.01));
        expect(cartManager.totalAmount, closeTo(0.0, 0.01));
      });

      test('should handle items with no discount', () {
        cartManager.addItem('1', 'iPhone', 1000.0, discount: 0.0);

        expect(cartManager.totalDiscount, 0.0);
        expect(cartManager.totalAmount, 1000.0);
      });
    });

    group('Total Calculation Tests', () {
      test('should calculate correct total for empty cart', () {
        expect(cartManager.subtotal, 0.0);
        expect(cartManager.totalDiscount, 0.0);
        expect(cartManager.totalAmount, 0.0);
        expect(cartManager.totalItems, 0);
      });

      test('should calculate correct totals for single item', () {
        cartManager.addItem('1', 'iPhone', 999.99);

        expect(cartManager.subtotal, 999.99);
        expect(cartManager.totalAmount, 999.99);
        expect(cartManager.totalItems, 1);
      });

      test('should calculate correct totals for multiple items', () {
        cartManager.addItem('1', 'iPhone', 999.99, discount: 0.1);
        cartManager.addItem('2', 'Galaxy', 899.99, discount: 0.15);
        cartManager.addItem('3', 'iPad', 1099.99);

        // Subtotal: 2999.97
        // Discounts: 99.999 + 134.9985 = 234.9975
        // Total: 2999.97 - 234.9975 = 2764.97
        expect(cartManager.subtotal, closeTo(2999.97, 0.01));
        expect(cartManager.totalDiscount, closeTo(235.0, 0.1));
        expect(cartManager.totalAmount, closeTo(2764.97, 0.1));
        expect(cartManager.totalItems, 3);
      });
    });

    group('Edge Case Tests', () {
      test('should handle very large quantities', () {
        cartManager.addItem('1', 'iPhone', 999.99);
        cartManager.updateQuantity('1', 100);

        expect(cartManager.totalItems, 100);
        expect(cartManager.subtotal, closeTo(99999.0, 1.0));
      });

      test('should handle very small prices', () {
        cartManager.addItem('1', 'Accessory', 0.99);

        expect(cartManager.subtotal, 0.99);
        expect(cartManager.totalAmount, 0.99);
      });

      test('should handle mixed operations', () {
        // Add items
        cartManager.addItem('1', 'iPhone', 999.99, discount: 0.1);
        cartManager.addItem('2', 'Galaxy', 899.99);
        cartManager.addItem('1', 'iPhone', 999.99, discount: 0.1);

        // Update quantity
        cartManager.updateQuantity('2', 2);

        // Remove an item
        cartManager.addItem('3', 'iPad', 1099.99);
        cartManager.removeItem('3');

        // iPhone: quantity 2, price 999.99, 10% discount = 1999.98 - 199.998 = 1799.982
        // Galaxy: quantity 2, price 899.99, no discount = 1799.98
        // Total: 3799.96 - 199.998 = 3599.962
        expect(cartManager.totalItems, 4);
        expect(cartManager.subtotal, closeTo(3799.96, 0.01));
        expect(cartManager.totalAmount, closeTo(3599.96, 0.1));
      });
    });
  });

  group('ShoppingCart Widget Tests', () {
    testWidgets('should display empty cart message initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('should add item when button clicked', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Cart is empty'), findsNothing);
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Total Items: 1'), findsOneWidget);
    });

    testWidgets('should update quantity for duplicate items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // Add iPhone twice
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add iPhone Again'));
      await tester.pump();

      // Should show quantity 2 for single item entry
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Total Items: 2'), findsOneWidget);
    });

    testWidgets('should calculate discount correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // iPhone has 10% discount
      expect(find.text('Discount: 10%'), findsOneWidget);
      expect(find.textContaining('Total Discount:'), findsOneWidget);
    });

    testWidgets('should remove item when delete button clicked', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Apple iPhone'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Apple iPhone'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('should clear cart when clear button clicked', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Samsung Galaxy'), findsOneWidget);

      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('should increase quantity with plus button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Total Items: 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Total Items: 2'), findsOneWidget);
    });

    testWidgets('should decrease quantity with minus button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Total Items: 2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('Total Items: 1'), findsOneWidget);
    });

    testWidgets('should remove item when quantity becomes 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Apple iPhone'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('Apple iPhone'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
    });
  });
}
