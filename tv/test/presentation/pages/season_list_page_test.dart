import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/pages/season_list_page.dart';
import 'package:tv/presentation/widgets/season_card.dart';

import '../../dummy_data/tv_dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          builder: (context) {
            return Container();
          },
        );
      },
    );
  }

  testWidgets('Page should display season card bar when loading',
      (WidgetTester tester) async {
    final seasonCardFinder = find.byType(SeasonCard);
    final listViewFinder = find.byType(ListView);
    final itemList = find.byTooltip('Season List item 1');
    await tester.pumpWidget(
      _makeTestableWidget(
        SeasonListPage(
          tv: testTvDetail,
        ),
      ),
    );
    expect(itemList, findsOneWidget);

    expect(seasonCardFinder, findsOneWidget);
    expect(listViewFinder, findsOneWidget);
    await tester.tap(itemList);
    await tester.pump();
  });
}
