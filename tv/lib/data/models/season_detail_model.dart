import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:core/core.dart';
import 'episode_model.dart';

class SeasonDetailModel extends Equatable {
  const SeasonDetailModel({
    required this.id,
    this.airDate,
    this.episodes = const [],
    this.name,
    this.overview,
    this.seasonDetailResponseId,
    this.posterPath,
    this.seasonNumber,
  });
  final String id;
  final DateTime? airDate;
  final List<EpisodeModel> episodes;
  final String? name;
  final String? overview;
  final int? seasonDetailResponseId;
  final String? posterPath;
  final int? seasonNumber;
  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        seasonDetailResponseId,
        posterPath,
        seasonNumber
      ];

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) =>
      SeasonDetailModel(
        id: json["_id"],
        airDate: DateTime.parse(json["air_date"]),
        episodes: List<EpisodeModel>.from(
            (json["episodes"] ?? []).map((x) => EpisodeModel.fromJson(x))),
        name: json["name"],
        overview: json["overview"],
        seasonDetailResponseId: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "air_date": airDate?.simpleDateString,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
        "name": name,
        "overview": overview,
        "id": seasonDetailResponseId,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };
  SeasonDetail toEntity() => SeasonDetail(
      id: id,
      airDate: airDate,
      episodes: episodes.map((e) => e.toEntity()).toList(),
      name: name == null || name!.isEmpty ? 'Name not Provided' : name!,
      overview: overview == null || overview!.isEmpty
          ? 'Overview not Provided'
          : overview!,
      seasonDetailResponseId: seasonDetailResponseId,
      posterPath: posterPath,
      seasonNumber: seasonNumber!);
}
