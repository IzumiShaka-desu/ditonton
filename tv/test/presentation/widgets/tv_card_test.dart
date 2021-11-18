import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/widgets/poster_image.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

import '../../dummy/tv_dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
      onGenerateRoute: (setting) => MaterialPageRoute(
        builder: (ctx) => TvCard(testTv),
      ),
    );
  }

  testWidgets('Page should display poster path', (WidgetTester tester) async {
    final progressBarFinder = find.byType(PosterImage);
    final inkwell = find.byType(InkWell);
    var newTv = testTv;
    newTv.name = null;
    newTv.overview = null;
    await tester.pumpWidget(
      _makeTestableWidget(
        TvCard(newTv),
      ),
    );

    expect(progressBarFinder, findsOneWidget);
    await tester.tap(inkwell);
  });
}
