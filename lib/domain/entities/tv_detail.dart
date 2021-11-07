import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

import 'genre.dart';

class TvDetail extends Equatable {
  TvDetail({
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
  int? numberOfEpisodes;
  int? numberOfSeasons;
  DateTime? firstAirDate;
  int? episodeRunTime;
  List<Genre> genres;
  int id;
  String? backdropPath;
  bool inProduction;
  DateTime? lastAirDate;
  List<Season> seasons;
  String? originalName;
  String overview;
  double? popularity;
  String posterPath;
  double? voteAverage;
  int? voteCount;
  String? status;
  String? name;
  Episode? lastEpisodeToAir;

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
