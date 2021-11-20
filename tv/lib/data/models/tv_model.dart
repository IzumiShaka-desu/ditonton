import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

class TvModel extends Equatable {
  const TvModel({
    this.backdropPath,
    this.originalLanguage,
    this.firstAirDate,
    this.genreIds = const [],
    this.id,
    this.name,
    this.originCountry = const [],
    this.originalName,
    this.overview,
    this.popularity,
    this.posterPath,
    this.voteAverage,
    this.voteCount,
  });
  final String? backdropPath;
  final String? firstAirDate;
  final List<int> genreIds;
  final int? id;
  final String? name;
  final List<String> originCountry;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final double? voteAverage;
  final int? voteCount;
  final String? originalLanguage;

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
        backdropPath: json["backdrop_path"],
        firstAirDate: json["first_air_date"],
        originalLanguage: json["original_language"],
        genreIds: List<int>.from((json["genre_ids"] ?? []).map((x) => x)),
        id: json["id"],
        name: json["name"],
        originCountry:
            List<String>.from((json["origin_country"] ?? []).map((x) => x)),
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );
  Tv toEntity() => Tv(
        id: id,
        backdropPath: backdropPath,
        firstAirDate: DateTime.tryParse(firstAirDate ?? ''),
        name: name,
        originCountry: originCountry,
        originalLanguage: originalLanguage,
        originalName: originalName,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );
  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "first_air_date": firstAirDate,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "name": name,
        "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genreIds,
        id,
        name,
        originCountry,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
        originalLanguage,
        firstAirDate,
      ];
}
