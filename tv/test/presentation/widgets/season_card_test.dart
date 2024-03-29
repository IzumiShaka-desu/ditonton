import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/widgets/season_card.dart';

import '../../dummy_data/tv_dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display poster path', (WidgetTester tester) async {
    final progressBarFinder = find.byTooltip('poster image');

    await tester.pumpWidget(
      _makeTestableWidget(
        SeasonCard(
          screenWidth: 950,
          season: testSeason,
        ),
      ),
    );

    expect(progressBarFinder, findsOneWidget);
  });
}
