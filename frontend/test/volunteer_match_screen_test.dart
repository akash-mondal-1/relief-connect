import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteer_app/screens/volunteer_match_screen.dart';

void main() {
  testWidgets('shows deterministic matching empty prompt', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: VolunteerMatchScreen()));

    expect(
      find.text('Describe your skills and run\na deterministic match.'),
      findsOneWidget,
    );
    expect(find.textContaining('Gemini'), findsNothing);
  });
}
