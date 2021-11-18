import 'package:equatable/equatable.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

class TvTable extends Equatable {
  const TvTable({
    required this.id,
    this.name,
    this.posterPath,
    this.overview,
  });
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  factory TvTable.fromJson(Map<String, dynamic> json) => TvTable(
        id: json["id"],
        name: json["name"],
        posterPath: json["posterPath"],
        overview: json["overview"],
      );

  factory TvTable.fromDTO(TvModel model) => TvTable(
        id: model.id!,
        name: model.name,
        overview: model.overview,
        posterPath: model.posterPath,
      );
  factory TvTable.fromEntity(TvDetail model) => TvTable(
        id: model.id,
        name: model.name,
        overview: model.overview,
        posterPath: model.posterPath,
      );

  Tv toEntity() => Tv.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: name,
      );
  @override
  List<Object?> get props => [id, name, posterPath, overview];

  Map<String, dynamic> toJson() => {
        'id': id,
        'overview': overview,
        'posterPath': posterPath,
        'name': name,
      };
}
