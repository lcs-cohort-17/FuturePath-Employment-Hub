import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/main.dart';

void main() {
  testWidgets('FuturePath app loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FuturePathApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('FuturePath'), findsOneWidget);
    expect(find.text('Sipho'), findsOneWidget);
  });
}