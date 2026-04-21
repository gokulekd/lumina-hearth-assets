import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_noise/main.dart';

void main() {
  testWidgets('Breath Noise home screen renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: BreathNoiseApp()));
    expect(find.text('Breath Noise'), findsOneWidget);
  });
}
