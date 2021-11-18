import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/season.dart';

class SeasonModel extends Equatable {
  const SeasonModel({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });
  final DateTime? airDate;
  final int? episodeCount;
  final int? id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        airDate: DateTime.tryParse(json["air_date"] ?? ''),
        episodeCount: json["episode_count"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "air_date":
            "${airDate?.year.toString().padLeft(4, '0')}-${airDate?.month.toString().padLeft(2, '0')}-${airDate?.day.toString().padLeft(2, '0')}",
        "episode_count": episodeCount,
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };
  @override
  List<Object?> get props =>
      [airDate, episodeCount, id, name, overview, posterPath, seasonNumber];

  Season toEntity() => Season(
        airDate: airDate ?? DateTime(0),
        episodeCount: episodeCount ?? 0,
        id: id,
        name: name == null || name!.isEmpty ? 'Name not Provided' : name!,
        overview: overview == null || overview!.isEmpty
            ? 'Overview not Provided'
            : overview!,
        posterPath: posterPath,
        seasonNumber: seasonNumber,
      );
}
