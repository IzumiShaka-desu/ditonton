import 'package:equatable/equatable.dart';

import 'episode.dart';

class SeasonDetail extends Equatable {
  SeasonDetail({
    required this.id,
    required this.airDate,
    this.episodes = const [],
    required this.name,
    required this.overview,
    required this.seasonDetailResponseId,
    required this.posterPath,
    required this.seasonNumber,
  });
  final String id;
  final DateTime? airDate;
  final List<Episode> episodes;
  final String name;
  final String overview;
  final int? seasonDetailResponseId;
  final String? posterPath;
  final int seasonNumber;
  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        seasonDetailResponseId,
        posterPath,
        seasonNumber,
      ];
}
