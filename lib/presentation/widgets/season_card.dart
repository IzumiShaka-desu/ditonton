import 'package:core/utils/constants.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/presentation/widgets/poster_image.dart';
import 'package:flutter/material.dart';

class SeasonCard extends StatelessWidget {
  const SeasonCard({
    Key? key,
    required this.season,
    required this.screenWidth,
  }) : super(key: key);

  final Season season;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: kTextTheme,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: PosterImage(
                  url: 'https://image.tmdb.org/t/p/w500${season.posterPath}',
                  width: screenWidth,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      '${season.name}',
                      style: kHeading6,
                    ),
                    Text(
                      '${season.airDate?.year} | ${season.episodeCount} episodes',
                      style: kSubtitle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${season.overview == null || season.overview!.isEmpty ? '-' : (season.overview!.length > 90 ? season.overview!.substring(0, 90) : season.overview!) + '...'}',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
