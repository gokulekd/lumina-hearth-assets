import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_hearth/main.dart';

void main() {
  testWidgets('Lumina Hearth home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: LuminaHearthApp()),
    );
    expect(find.text('Lumina Hearth'), findsOneWidget);
  });
}
