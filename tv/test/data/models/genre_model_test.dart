import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/genre_model.dart';
import 'package:tv/domain/entities/tv_genre.dart';

void main() {
  const id = 2;
  const name = 'nme';
  const GenreModel testModel = GenreModel(
    id: id,
    name: name,
  );
  final testJsonMap = {
    "id": id,
    'name': name,
  };
  const testEntity = TvGenre(id: id, name: name);
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
