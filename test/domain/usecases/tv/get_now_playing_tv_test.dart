import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvs usecase;
  late MockTvRepository mockTvRepository;
  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetNowPlayingTvs(mockTvRepository);
  });
  final testTv = <Tv>[];
  test('should get list of tv when call getNowPlayingTvs on repository',
      () async {
    //arrange
    when(mockTvRepository.getNowPlayingTvs())
        .thenAnswer((_) async => Right(testTv));
    //act
    final result = await usecase.execute();
    //assert
    verify(mockTvRepository.getNowPlayingTvs());
    expect(result, Right(testTv));
  });
}
