import 'package:flutter_test/flutter_test.dart';
import 'package:home_services/main.dart';

void main() {
  testWidgets('HomeServe Pro opens role selection', (tester) async {
    await tester.pumpWidget(const HomeServeApp());
    expect(find.text('HomeServe Pro'), findsOneWidget);
    expect(find.text('Continue as'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Worker'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
  });
}
