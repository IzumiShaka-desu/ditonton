import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvs usecase;
  late MockTvRepository repository;
  setUp(() {
    repository = MockTvRepository();
    usecase = GetPopularTvs(repository);
  });
  final testTv = <Tv>[];
  test('should get list of tv when call getPopularTvs on repository', () async {
    //arrange

    when(repository.getPopularTvs()).thenAnswer((_) async => Right(testTv));
    //act
    final result = await usecase.execute();
    //assert
    verify(repository.getPopularTvs());
    expect(result, Right(testTv));
  });
}
