import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteer_app/screens/report_need_screen.dart';

void main() {
  testWidgets('shows validation errors for empty required fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReportNeedScreen()));

    await tester.tap(find.text('Submit Need'));
    await tester.pump();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Location is required'), findsOneWidget);
    expect(find.text('Description required'), findsOneWidget);
  });
}
