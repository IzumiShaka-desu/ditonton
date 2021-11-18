import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/season.dart';

import 'episode.dart';
import 'genre.dart';

class TvDetail extends Equatable {
  const TvDetail({
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.firstAirDate,
    this.episodeRunTime,
    this.genres = const [],
    required this.id,
    this.backdropPath,
    required this.inProduction,
    this.lastAirDate,
    this.seasons = const [],
    this.originalName,
    required this.overview,
    this.popularity,
    required this.posterPath,
    this.voteAverage,
    this.voteCount,
    this.status,
    this.name,
    this.lastEpisodeToAir,
  });
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final DateTime? firstAirDate;
  final int? episodeRunTime;
  final List<Genre> genres;
  final int id;
  final String? backdropPath;
  final bool inProduction;
  final DateTime? lastAirDate;
  final List<Season> seasons;
  final String? originalName;
  final String overview;
  final double? popularity;
  final String posterPath;
  final double? voteAverage;
  final int? voteCount;
  final String? status;
  final String? name;
  final Episode? lastEpisodeToAir;
  @override
  List<Object?> get props => [
        numberOfEpisodes,
        numberOfSeasons,
        firstAirDate,
        episodeRunTime,
        genres,
        id,
        backdropPath,
        inProduction,
        lastAirDate,
        seasons,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
        status,
        name,
        lastEpisodeToAir,
      ];
}
