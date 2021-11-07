import 'package:ditonton/presentation/widgets/poster_image.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (ctx) => MovieCard(testMovie)),
    );
  }

  testWidgets('Page should display poster path', (WidgetTester tester) async {
    final posterImage = find.byType(PosterImage);
    final inkwell = find.byType(InkWell);
    var newTestMovie = testMovie;
    newTestMovie.title = null;
    newTestMovie.overview = null;
    await tester.pumpWidget(
      _makeTestableWidget(
        MovieCard(testMovie),
      ),
    );

    expect(posterImage, findsOneWidget);
    await tester.tap(inkwell);
  });
}
