import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/main.dart';

void main() {
  testWidgets('shows first app greeting', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('First App'), findsOneWidget);
    expect(find.text('Hello from first app'), findsOneWidget);
  });
}
