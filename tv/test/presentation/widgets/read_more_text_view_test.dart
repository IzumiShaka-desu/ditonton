import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/widgets/read_more_text_view.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
    );
  }

  testWidgets('verify read more text view  widgetbehaviour', (tester) async {
    final txt = "lorem" * 20;
    await tester.pumpWidget(
      _makeTestableWidget(
        ReadMoreTextView(
          text: txt,
          maxCharacter: 60,
        ),
      ),
    );
    var button = find.widgetWithText(TextButton, "show more");
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pump();
    var button2 = find.widgetWithText(TextButton, "show less");
    expect(button2, findsOneWidget);
    await tester.tap(button2);
    await tester.pump();
    button = find.widgetWithText(TextButton, "show more");
    expect(button, findsOneWidget);
  });
}
