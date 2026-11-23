import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_colors_app/main.dart';

void main() {
  testWidgets('Random Colors shows text and changes background on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RandomColorsApp());

    expect(find.text('Tap the button to change colors!'), findsOneWidget);
    final initialColor = tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor;

    await tester.tap(find.byIcon(Icons.color_lens));
    await tester.pump();

    final changedColor = tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor;
    expect(changedColor, isNot(initialColor));
  });
}
