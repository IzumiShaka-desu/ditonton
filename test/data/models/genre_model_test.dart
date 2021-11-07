import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final GenreModel testModel = GenreModel(
    id: 1,
    name: 'name',
  );
  final testJsonMap = {
    "id": 1,
    'name': 'name',
  };
  final testEntity = Genre(
    id: 1,
    name: 'name',
  );
  test('should return a valid model from JSON', () async {
    final result = GenreModel.fromJson(testJsonMap);
    expect(result, testModel);
  });
  test('should return a JSON map containing proper data', () {
    final jsonMap = testModel.toJson();
    expect(jsonMap, testJsonMap);
  });
  test('should return a valid entity', () {
    final entity = testModel.toEntity();
    expect(entity, testEntity);
  });
}
