import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';

import '../../dummy/tv_dummy_objects.dart';
import 'season_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetSeasonDetail,
])
void main() {
  late SeasonDetailNotifier provider;
  late int listenerCallCount;
  late GetSeasonDetail mockGetSeasonDetail;

  setUp(() {
    listenerCallCount = 0;

    mockGetSeasonDetail = MockGetSeasonDetail();
    provider = SeasonDetailNotifier(
      getSeasonDetail: mockGetSeasonDetail,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tId = 1;

  void _arrangeUsecase() {
    when(mockGetSeasonDetail.execute(tId, tId))
        .thenAnswer((_) async => Right(testSeasonDetail));
  }

  group('Get Season Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tvId: tId, seasonNumber: tId);
      // assert
      verify(mockGetSeasonDetail.execute(tId, tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchSeasonDetail(seasonNumber: tId, tvId: tId);
      // assert
      expect(provider.seasonState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change season when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(seasonNumber: tId, tvId: tId);
      // assert
      expect(provider.seasonState, RequestState.Loaded);
      expect(provider.season, testSeasonDetail);
      expect(listenerCallCount, 3);
    });

    test(
        'should change recommendation seasons when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(seasonNumber: tId, tvId: tId);
      // assert
      expect(provider.seasonState, RequestState.Loaded);
    });
  });

  group('Get Season Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(seasonNumber: tId, tvId: tId);
      // assert
      verify(mockGetSeasonDetail.execute(tId, tId));
    });

    group('on Error', () {
      test('should return error when data is unsuccessful', () async {
        // arrange
        when(mockGetSeasonDetail.execute(tId, tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        // act
        await provider.fetchSeasonDetail(seasonNumber: tId, tvId: tId);
        // assert
        expect(provider.seasonState, RequestState.Error);
        expect(provider.message, 'Server Failure');
        expect(listenerCallCount, 2);
      });
    });
  });
}
