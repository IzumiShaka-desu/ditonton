import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeasonDetail usecase;
  late MockTvRepository mockSeasonRepository;

  setUp(() {
    mockSeasonRepository = MockTvRepository();
    usecase = GetSeasonDetail(mockSeasonRepository);
  });

  final tId = 1;

  test('should get season detail from the repository', () async {
    // arrange
    when(mockSeasonRepository.getSeasonDetail(tId, tId))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    final result = await usecase.execute(tId, tId);
    // assert
    verify(mockSeasonRepository.getSeasonDetail(tId, tId));
    expect(result, Right(testSeasonDetail));
  });
}
