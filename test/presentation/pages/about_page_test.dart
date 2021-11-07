import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
    );
  }

  testWidgets('Page should display back button', (WidgetTester tester) async {
    final button = find.byIcon(Icons.arrow_back);

    await tester.pumpWidget(
      _makeTestableWidget(AboutPage()),
    );
    await tester.tap(button);
    await tester.pump();
    expect(button, findsOneWidget);
  });
}
