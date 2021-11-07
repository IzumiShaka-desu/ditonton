import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  Episode({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });
  DateTime? airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  int seasonNumber;
  String stillPath;
  double? voteAverage;
  int? voteCount;
  double get voteAverageNonNull => voteAverage ?? 0;
  @override
  List<Object?> get props => [
        id,
        airDate,
        episodeNumber,
        name,
        overview,
        seasonNumber,
        stillPath,
        voteAverage,
        voteCount,
      ];
}
