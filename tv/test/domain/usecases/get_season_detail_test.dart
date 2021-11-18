import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';

import '../../dummy/tv_dummy_objects.dart';
import '../../tv_test.mocks.dart';

void main() {
  late GetSeasonDetail usecase;
  late MockTvRepository mockSeasonRepository;

  setUp(() {
    mockSeasonRepository = MockTvRepository();
    usecase = GetSeasonDetail(mockSeasonRepository);
  });

  const tId = 1;

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
