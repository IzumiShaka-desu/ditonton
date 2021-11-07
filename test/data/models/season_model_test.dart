import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testJsonMap = {
    "air_date": "2021-09-17",
    "episode_count": 9,
    "id": 131977,
    "name": "Season 1",
    "overview":
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
    "poster_path": "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
    "season_number": 1
  };
  final testModel = SeasonModel(
      airDate: DateTime(2021, 09, 17),
      episodeCount: 9,
      id: 131977,
      name: "Season 1",
      overview:
          "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
      posterPath: "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
      seasonNumber: 1);
  final testEntity = Season(
      airDate: DateTime(2021, 09, 17),
      episodeCount: 9,
      id: 131977,
      name: "Season 1",
      overview:
          "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
      posterPath: "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
      seasonNumber: 1);
  test('return valid model from json', () {
    //arrange

    final result = SeasonModel.fromJson(testJsonMap);
    //act
    //assert
    expect(result, testModel);
  });
  test('return a valid jsonMap from a model', () {
    //arrange
    final jsonMap = testModel.toJson();
    //act
    //assert
    expect(jsonMap, testJsonMap);
  });
  test('return a valid entity from model', () {
    //arrange
    final entity = testModel.toEntity();
    //act
    //assert
    expect(entity, testEntity);
  });
}
