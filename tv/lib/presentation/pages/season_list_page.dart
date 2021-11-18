import 'package:flutter/material.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:tv/presentation/widgets/season_card.dart';

class SeasonListPage extends StatelessWidget {
  const SeasonListPage({Key? key, required this.tv}) : super(key: key);
  static const ROUTE_NAME = '/season-list';
  final TvDetail tv;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var seasons = tv.seasons;
    return Scaffold(
      appBar: AppBar(
        title: Text('Season List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final season = seasons[index];
            return Tooltip(
              message: 'Season List item ${index + 1}',
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SeasonDetailPage.routeName,
                    arguments: {
                      "season": season,
                      "tvId": tv.id,
                      "coverImageUrl":
                          'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                    },
                  );
                },
                child: SeasonCard(
                  screenWidth: screenWidth,
                  season: season,
                ),
              ),
            );
          },
          itemCount: seasons.length,
        ),
      ),
    );
  }
}
