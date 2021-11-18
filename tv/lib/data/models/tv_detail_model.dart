import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/genre.dart';
import 'package:tv/domain/entities/tv_detail.dart';

import 'episode_model.dart';
import 'genre_model.dart';
import 'season_model.dart';

class TvDetailModel extends Equatable {
  const TvDetailModel({
    required this.backdropPath,
    this.episodeRunTime = const [],
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.voteAverage,
    required this.voteCount,
  });
  final String? backdropPath;
  final List<int> episodeRunTime;
  final DateTime? firstAirDate;
  final List<GenreModel>? genres;
  final int? id;
  final bool? inProduction;
  final List<String>? languages;
  final DateTime? lastAirDate;
  final EpisodeModel? lastEpisodeToAir;
  final String? name;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<SeasonModel>? seasons;
  final String? status;
  final double? voteAverage;
  final int? voteCount;

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
        backdropPath: json["backdrop_path"],
        episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        firstAirDate: DateTime.tryParse(json["first_air_date"]),
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        inProduction: json["in_production"],
        languages: List<String>.from(json["languages"].map((x) => x)),
        lastAirDate: DateTime.tryParse(json["last_air_date"]),
        lastEpisodeToAir: EpisodeModel.fromJson(json["last_episode_to_air"]),
        name: json["name"],
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        seasons: List<SeasonModel>.from(
            json["seasons"].map((x) => SeasonModel.fromJson(x))),
        status: json["status"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "episode_run_time": List<dynamic>.from(episodeRunTime.map((x) => x)),
        "first_air_date":
            "${firstAirDate?.year.toString().padLeft(4, '0')}-${firstAirDate?.month.toString().padLeft(2, '0')}-${firstAirDate?.day.toString().padLeft(2, '0')}",
        "genres": List<dynamic>.from((genres ?? []).map((x) => x.toJson())),
        "id": id,
        "in_production": inProduction,
        "languages": List<dynamic>.from((languages ?? []).map((x) => x)),
        "last_air_date":
            "${lastAirDate?.year.toString().padLeft(4, '0')}-${lastAirDate?.month.toString().padLeft(2, '0')}-${lastAirDate?.day.toString().padLeft(2, '0')}",
        "last_episode_to_air": lastEpisodeToAir?.toJson(),
        "name": name,
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "origin_country":
            List<dynamic>.from((originCountry ?? []).map((x) => x)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "seasons": List<dynamic>.from((seasons ?? []).map((x) => x.toJson())),
        "status": status,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  @override
  List<Object?> get props => [
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        id,
        inProduction,
        languages,
        lastAirDate,
        lastEpisodeToAir,
        name,
        numberOfEpisodes,
        numberOfSeasons,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        seasons,
        status,
        voteAverage,
        voteCount,
        lastEpisodeToAir,
      ];

  TvDetail toEntity() => TvDetail(
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      firstAirDate: firstAirDate,
      episodeRunTime: (episodeRunTime..sort()).last,
      genres:
          (genres ?? []).map((e) => e.toEntity()).whereType<Genre>().toList(),
      id: id!,
      backdropPath: backdropPath,
      inProduction: inProduction!,
      lastAirDate: lastAirDate,
      seasons: seasons?.map((e) => e.toEntity()).toList() ?? [],
      originalName: originalName,
      overview: '$overview',
      popularity: popularity,
      posterPath: posterPath!,
      voteAverage: voteAverage,
      voteCount: voteCount,
      status: status,
      name: name,
      lastEpisodeToAir: lastEpisodeToAir?.toEntity());
}
