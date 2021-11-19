import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv_genre.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/cubit/detail_tv/detail_tv_cubit.dart';
import 'package:tv/presentation/widgets/poster_image.dart';
import 'package:tv/presentation/widgets/season_card.dart';

import 'season_detail_page.dart';
import 'season_list_page.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  const TvDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<DetailTvCubit>().loadDetailTv(
            widget.id,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailTvCubit>().state;
    if (state is ErrorDetailTvsState) {
      return Tooltip(
        message: 'error message',
        child: Text(state.message),
      );
    }
    if (state is LoadedWithRecommendationListDetailTvsState) {
      return SafeArea(
        child: DetailContent(
          state.tvDetail,
          state.recommendationTvs,
          state.isAddedtoWatchlistTvs,
        ),
      );
    }
    if (state is LoadedWithRecommendationErrorDetailTvsState) {
      return SafeArea(
        child: DetailContent(
          state.tvDetail,
          const [],
          state.isAddedtoWatchlistTvs,
          errorMessage: state.recommendationError,
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;
  final String? errorMessage;
  const DetailContent(
    this.tv,
    this.recommendations,
    this.isAddedWatchlist, {
    Key? key,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        PosterImage(
          url: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name ?? '',
                              style: kHeading5,
                            ),
                            Text(
                              tv.status ?? '',
                              style: kSubtitle,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await context
                                      .read<DetailTvCubit>()
                                      .addWatchlist(tv);
                                } else {
                                  await context
                                      .read<DetailTvCubit>()
                                      .removeFromWatchlist(tv);
                                }

                                final message =
                                    context.read<DetailTvCubit>().message;

                                if (message ==
                                        DetailTvCubit
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        DetailTvCubit
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(message),
                                  ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              tv.episodeRunTime == null
                                  ? '-'
                                  : _showDuration(tv.episodeRunTime!),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage == null
                                      ? 0
                                      : tv.voteAverage! / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Last airing Season',
                                  style: kHeading6,
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      SeasonListPage.ROUTE_NAME,
                                      arguments: tv,
                                    );
                                  },
                                  icon:
                                      const Icon(Icons.remove_red_eye_outlined),
                                  label: const Text('View all Season'),
                                ),
                              ],
                            ),
                            tv.seasons.isEmpty
                                ? const SizedBox(
                                    child: Text('No Season has aired'),
                                  )
                                : Tooltip(
                                    message: 'last airing season',
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          SeasonDetailPage.routeName,
                                          arguments: {
                                            "season": tv.seasons.last,
                                            "tvId": tv.id,
                                            "coverImageUrl":
                                                'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                          },
                                        );
                                      },
                                      child: SeasonCard(
                                        screenWidth: screenWidth,
                                        season: tv.seasons.last,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _RecommendationItems(
                                recommendations: recommendations,
                                errorMessage: errorMessage),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<TvGenre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _RecommendationItems extends StatelessWidget {
  const _RecommendationItems({
    Key? key,
    required this.recommendations,
    this.errorMessage,
  }) : super(key: key);
  final String? errorMessage;
  final List<Tv> recommendations;

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Tooltip(
        message: 'Recommendation error',
        child: Text(errorMessage!),
      );
    }
    if (recommendations.isEmpty) {
      return const Tooltip(
        message: 'Recommendation empty',
        child: SizedBox(),
      );
    }
    return Container(
      height: 150,
      child: Tooltip(
        message: 'Recommendation list',
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final tv = recommendations[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Tooltip(
                message: 'Recommendation item ${index + 1}',
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
                      arguments: tv.id,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: PosterImage(
                      url: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: recommendations.length,
        ),
      ),
    );
  }
}
