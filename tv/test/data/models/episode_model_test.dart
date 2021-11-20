import 'package:core/utils/datetime_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/domain/entities/episode.dart';

void main() {
  final now = DateTime.now();

  final EpisodeModel testEpsModel = EpisodeModel(
    episodeNumber: 1,
    airDate: DateTime.tryParse(now.simpleDateString),
    id: 1,
    name: 'name',
    overview: 'overview',
    productionCode: '',
    seasonNumber: 1,
    stillPath: '',
    voteAverage: 2.0,
    voteCount: 2000,
  );
  final EpisodeModel testEpsModelNulled = EpisodeModel(
    episodeNumber: 1,
    airDate: DateTime.tryParse(now.simpleDateString),
    id: 1,
    name: 'name',
    overview: 'overview',
    productionCode: '',
    seasonNumber: 1,
    stillPath: '',
    voteCount: 2000,
  );
  final Episode testEntity = Episode(
    episodeNumber: 1,
    airDate: DateTime.tryParse(now.simpleDateString),
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    stillPath: '',
    voteAverage: 2.0,
    voteCount: 2000,
  );
  final testJsonMap = {
    "air_date":
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    "episode_number": 1,
    "id": 1,
    "name": 'name',
    "overview": 'overview',
    "production_code": '',
    "season_number": 1,
    "still_path": '',
    "vote_average": 2.0,
    "vote_count": 2000,
  };
  test('should return a valid model from JSON', () async {
    final result = EpisodeModel.fromJson(testJsonMap);
    expect(result, testEpsModel);
  });
  test('should return a JSON map containing proper data', () {
    final jsonMap = testEpsModel.toJson();
    expect(jsonMap, testJsonMap);
  });
  test('should return valid entity', () {
    final entity = testEpsModel.toEntity();
    final entity2 = testEpsModelNulled.toEntity();
    expect(entity2.voteAverageNonNull, 0);
    expect(entity, testEntity);
  });
}
