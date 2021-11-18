import 'package:equatable/equatable.dart';

class Season extends Equatable {
  const Season({
    required this.airDate,
    this.episodeCount = 0,
    this.id,
    this.name = "Name not provided",
    this.overview = 'Overview not Provided',
    this.posterPath,
    this.seasonNumber,
  });

  final DateTime airDate;
  final int episodeCount;
  final int? id;
  final String name;
  final String overview;
  final String? posterPath;
  final int? seasonNumber;

  @override
  List<Object?> get props => [
        airDate,
        episodeCount,
        id,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}
