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
  String id;
  DateTime? airDate;
  List<Episode> episodes;
  String name;
  String overview;
  int? seasonDetailResponseId;
  String? posterPath;
  int seasonNumber;
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
