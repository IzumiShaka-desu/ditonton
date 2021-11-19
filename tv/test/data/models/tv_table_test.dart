import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv_genre.dart';

void main() {
  const testTable = TvTable(
    id: 1,
    name: 'nama',
    posterPath: 'path',
    overview: 'overview',
  );
  final testEntity = Tv.watchlist(
    id: 1,
    name: 'nama',
    posterPath: 'path',
    overview: 'overview',
  );

  const testModel = TvModel(
    id: 1,
    name: 'nama',
    posterPath: 'path',
    overview: 'overview',
  );
  const testTvDetail = TvDetail(
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      firstAirDate: null,
      episodeRunTime: 43,
      genres: [TvGenre(id: 1, name: '2')],
      id: 1,
      backdropPath: null,
      inProduction: false,
      lastAirDate: null,
      seasons: [],
      originalName: 'nama',
      overview: 'overview',
      popularity: 1,
      posterPath: 'path',
      voteAverage: 1,
      voteCount: 1,
      status: 'status',
      name: 'nama',
      lastEpisodeToAir: null);
  final testJsonMap = {
    'id': 1,
    'name': 'nama',
    'posterPath': 'path',
    'overview': 'overview',
  };
  test('should return valid table from model', () {
    //arrange
    //act
    final result = TvTable.fromDTO(testModel);
    //assert
    expect(result, testTable);
  });
  test('should return valid table from json', () {
    //arrange
    //act
    final result = TvTable.fromJson(testJsonMap);
    //assert
    expect(result, testTable);
  });
  test('should return valid table from entity', () {
    //arrange
    //act
    final result = TvTable.fromEntity(testTvDetail);
    //assert
    expect(result, testTable);
  });
  test('should return valid entity from table', () {
    //arrange
    //act
    final result = testTable.toEntity();
    //assert
    expect(result, testEntity);
  });
  test('should return valid jsonMap from table', () {
    //arrange
    //act
    final result = testTable.toJson();
    //assert
    expect(result, testJsonMap);
  });
}
