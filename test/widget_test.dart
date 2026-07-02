// Basic smoke test for the PharmacyApp.
import 'package:flutter_test/flutter_test.dart';
import 'package:assignmet_omway/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PharmacyApp());
    expect(find.byType(PharmacyApp), findsOneWidget);
  });
}
