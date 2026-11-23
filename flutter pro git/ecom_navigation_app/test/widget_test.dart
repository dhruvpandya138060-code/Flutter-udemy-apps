import 'package:ecom_navigation_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash navigates to login, then registration', (tester) async {
    await tester.pumpWidget(const EcomApp());
    expect(find.text('Ecom App'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsWidgets);
    expect(find.text('New User? Register here'), findsOneWidget);

    await tester.tap(find.text('New User? Register here'));
    await tester.pumpAndSettle();
    expect(find.text('Register'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(4));
  });

  testWidgets('Login passes Dhruv to Dashboard using named route', (tester) async {
    await tester.pumpWidget(const EcomApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'dhruv@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Hi, Dhruv!'), findsOneWidget);
  });
}
