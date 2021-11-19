import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Tv extends Equatable {
  Tv({
    required this.id,
    required this.backdropPath,
    required this.firstAirDate,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });
  String? backdropPath;
  DateTime? firstAirDate;
  int? id;
  String? name;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  Tv.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });
  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        id,
        name,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
