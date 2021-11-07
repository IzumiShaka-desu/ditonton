import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository repository;
  late GetTopRatedTvs usecase;
  setUp(() {
    repository = MockTvRepository();
    usecase = GetTopRatedTvs(repository);
  });
  final testTv = <Tv>[];
  test('should get list of tv when call getTopRated on repository', () async {
    //arrange
    when(repository.getTopRatedTvs())
        .thenAnswer((realInvocation) async => Right(testTv));
    //act
    final result = await usecase.execute();
    //assert
    verify(repository.getTopRatedTvs());
    expect(result, Right(testTv));
  });
}
