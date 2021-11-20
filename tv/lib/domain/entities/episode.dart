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
  final DateTime? airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final String stillPath;
  final double? voteAverage;
  final int? voteCount;
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
