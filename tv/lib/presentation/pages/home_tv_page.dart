import 'package:core/core.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tv/presentation/widgets/poster_image.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/cubit/tv_list/tv_list_cubit.dart';

import 'popular_tvs_page.dart';
import 'top_rated_tvs_page.dart';
import 'tv_detail_page.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({Key? key}) : super(key: key);

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    fetchTvs();
  }

  void fetchTvs() {
    Future.microtask(
      () => context.read<TvListCubit>().loadTvList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TvListCubit>().state;

    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: state is ErrorTvListState
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("cannot establish connection"),
                    const Icon(
                        Icons.signal_wifi_connected_no_internet_4_outlined),
                    TextButton(
                      onPressed: fetchTvs,
                      child: const Text("Retry"),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Now Playing',
                      style: kHeading6,
                    ),
                    const _NowPlayingTvs(),
                    _buildSubHeading(
                      title: 'Popular',
                      onTap: () => Navigator.pushNamed(
                          context, PopularTvsPage.ROUTE_NAME),
                    ),
                    const _PopularTvs(),
                    _buildSubHeading(
                      title: 'Top Rated',
                      onTap: () => Navigator.pushNamed(
                          context, TopRatedTvsPage.ROUTE_NAME),
                    ),
                    const _TopRatedTvs(),
                  ],
                ),
              ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        Tooltip(
          message: 'navigate to $title',
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text('See More'),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  const TvList(this.tvs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                child: PosterImage(
                  url: '$BASE_IMAGE_URL${tv.posterPath}',
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}

class _NowPlayingTvs extends StatelessWidget {
  const _NowPlayingTvs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TvListCubit>().state;
    if (state is LoadedTvListState) {
      if (state.nowPlaying.isEmpty) {
        return const Tooltip(
          message: 'failed to load tvs',
          child: Text('Failed'),
        );
      }
      return TvList(state.nowPlaying);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _PopularTvs extends StatelessWidget {
  const _PopularTvs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TvListCubit>().state;
    if (state is LoadedTvListState) {
      if (state.popular.isEmpty) {
        return const Tooltip(
          message: 'failed to load tvs',
          child: Text('Failed'),
        );
      }
      return TvList(state.popular);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _TopRatedTvs extends StatelessWidget {
  const _TopRatedTvs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TvListCubit>().state;
    if (state is LoadedTvListState) {
      if (state.topRated.isEmpty) {
        return const Tooltip(
          message: 'failed to load tvs',
          child: Text('Failed'),
        );
      }
      return TvList(state.topRated);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

// class TvList extends StatelessWidget {
//   final List<Tv> tvs;

//   TvList(this.tvs);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           final tv = tvs[index];
//           return Container(
//             padding: const EdgeInsets.all(8),
//             child: InkWell(
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   TvDetailPage.ROUTE_NAME,
//                   arguments: tv.id,
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(16),
//                 ),
//                 child: PosterImage(
//                   url: '$BASE_IMAGE_URL${tv.posterPath}',
//                 ),
//               ),
//             ),
//           );
//         },
//         itemCount: tvs.length,
//       ),
//     );
//   }
// }
