import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_id/app/app.dart';

void main() {
  testWidgets('app launches splash route', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StudentIdApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(StudentIdApp), findsOneWidget);
  });
}
