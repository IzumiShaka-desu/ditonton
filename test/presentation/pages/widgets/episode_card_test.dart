import 'package:ditonton/presentation/widgets/episode_card.dart';
import 'package:ditonton/presentation/widgets/poster_image.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_objects.dart';

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
        EpisodeCard(
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
