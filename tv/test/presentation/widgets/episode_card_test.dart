import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/widgets/episode_card.dart';
import 'package:tv/presentation/widgets/poster_image.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
    );
  }

  testWidgets('Page should display poster path', (WidgetTester tester) async {
    final posterImage = find.byType(PosterImage);

    await tester.pumpWidget(
      _makeTestableWidget(
        const EpisodeCard(
            episodeNumber: 1,
            name: 'name',
            urlImage: 'urlImage',
            voteAverage: 3,
            overview: 'overview'),
      ),
    );

    expect(posterImage, findsOneWidget);
  });
}
