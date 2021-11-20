import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/presentation/bloc/cubit/detail_season/detail_season_cubit.dart';
import 'package:tv/presentation/widgets/custom_sliver_header.dart';
import 'package:tv/presentation/widgets/episode_card.dart';
import 'package:tv/presentation/widgets/poster_image.dart';

class SeasonDetailPage extends StatefulWidget {
  const SeasonDetailPage(
      {Key? key,
      required this.coverImageUrl,
      required this.season,
      required this.tvId})
      : super(key: key);
  static const routeName = 'season-detail';
  final String coverImageUrl;
  final int tvId;
  final Season season;

  @override
  State<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  late final ScrollController _scrollController;
  double scrollOffset = 0;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if ((scrollOffset > 100 && _scrollController.offset < 100) ||
          _scrollController.offset > 100 && scrollOffset < 100) {
        setState(() {
          scrollOffset = _scrollController.offset;
        });
      }
    });
    Future.microtask(
      () => context.read<DetailSeasonCubit>().loadDetailSeason(
            widget.tvId,
            widget.season.seasonNumber ?? 0,
          ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) => [
              SliverPersistentHeader(
                delegate: _SeasonDetailSliverAppBar(
                  expandedHeight: 200,
                  coverImageUrl: widget.coverImageUrl,
                  season: widget.season,
                ),
                pinned: true,
              ),
              SliverAnimatedOpacity(
                duration: const Duration(milliseconds: 350),
                opacity: scrollOffset > 100 ? 1 : 0,
                sliver: SliverPersistentHeader(
                  delegate: CustomSliverHeader(
                    const TabBar(
                      tabs: [
                        Tooltip(
                          message: 'navigate to information',
                          child: Tab(
                            text: "information",
                          ),
                        ),
                        Tooltip(
                          message: 'navigate to episodes',
                          child: Tab(
                            text: "episodes",
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: kColorScheme.background,
                  ),
                  pinned: true,
                ),
              ),
            ],
            body: const _SeasonDetailBodyView(),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabPageSelector(
              color: kMikadoYellow.withOpacity(0.5),
              selectedColor: kMikadoYellow,
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonDetailBodyView extends StatelessWidget {
  const _SeasonDetailBodyView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        _InformationDetailSeasonView(),
        _EpisodeListview(),
      ],
    );
  }
}

class _EpisodeListview extends StatelessWidget {
  const _EpisodeListview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailSeasonCubit>().state;
    if (state is ErrorDetailSeasonState) {
      return Tooltip(
        message: 'error message',
        child: Text(state.message),
      );
    }
    if (state is LoadedDetailSeasonState) {
      return Tooltip(
        message: 'episodes list',
        child: ListView.builder(
          itemCount: state.seasonDetail.episodes.length + 1,
          itemBuilder: (ctx, index) {
            int newIndex = index - 1;
            if (newIndex == -1) {
              return Container(
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total ${state.seasonDetail.episodes.length} episodes ',
                        style: kHeading6,
                      ),
                    )
                  ],
                ),
              );
            }
            var episode = state.seasonDetail.episodes.elementAt(newIndex);
            return EpisodeCard(
              episodeNumber: episode.episodeNumber,
              name: episode.name,
              overview: episode.overview,
              urlImage: 'https://image.tmdb.org/t/p/w500${episode.stillPath}',
              voteAverage: episode.voteAverageNonNull,
            );
          },
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _InformationDetailSeasonView extends StatelessWidget {
  const _InformationDetailSeasonView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailSeasonCubit>().state;
    if (state is ErrorDetailSeasonState) {
      return Tooltip(
        message: 'error message',
        child: Text(state.message),
      );
    }
    if (state is LoadedDetailSeasonState) {
      final season = state.seasonDetail;
      return ListView(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'First Airing date ',
              style: kHeading6,
            ),
          ),
          Text(
            "${season.airDate?.toString().split(" ").first ?? "no date provided"}",
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Overview ',
              style: kHeading6,
            ),
          ),
          Text(
            "${season.overview.isEmpty ? "no overview provided." : season.overview}",
          ),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _SeasonDetailSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String coverImageUrl;
  final Season season;

  const _SeasonDetailSliverAppBar(
      {required this.season,
      required this.coverImageUrl,
      required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        PosterImage(
          url: coverImageUrl,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        AnimatedOpacity(
          opacity: shrinkOffset / expandedHeight,
          duration: const Duration(milliseconds: 300),
          child: Container(
            color: kColorScheme.background,
          ),
        ),
        AnimatedAlign(
          alignment: shrinkOffset / expandedHeight < 0.9
              ? Alignment.bottomLeft
              : Alignment.bottomCenter,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              season.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2.5 - shrinkOffset,
          right: size.width / 16,
          child: AnimatedOpacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            duration: const Duration(milliseconds: 300),
            child: Card(
              elevation: 10,
              child: PosterImage(
                width: size.width / 3,
                url: 'https://image.tmdb.org/t/p/w500${season.posterPath}',
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: kRichBlack,
                  foregroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
