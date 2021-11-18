import 'package:core/core.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie/presentation/widgets/poster_image.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';

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
    Future.microtask(
      () => Provider.of<TvListNotifier>(context, listen: false)
        ..fetchNowPlayingTvs()
        ..fetchPopularTvs()
        ..fetchTopRatedTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              Consumer<TvListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                switch (state) {
                  case RequestState.Loaded:
                    return TvList(data.nowPlayingTvs);
                  case RequestState.Loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case RequestState.Empty:
                  case RequestState.Error:
                    return Tooltip(
                      message: 'failed to load tvs',
                      child: Text('Failed'),
                    );
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
              ),
              Consumer<TvListNotifier>(builder: (context, data, child) {
                final state = data.popularTvsState;
                switch (state) {
                  case RequestState.Loaded:
                    return TvList(data.popularTvs);

                  case RequestState.Loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case RequestState.Empty:
                  case RequestState.Error:
                    return Tooltip(
                      message: 'failed to load tvs',
                      child: Text('Failed'),
                    );
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
              ),
              Consumer<TvListNotifier>(builder: (context, data, child) {
                final state = data.topRatedTvsState;
                switch (state) {
                  case RequestState.Loaded:
                    return TvList(data.topRatedTvs);

                  case RequestState.Loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case RequestState.Empty:
                  case RequestState.Error:
                    return Tooltip(
                      message: 'failed to load tvs',
                      child: Text('Failed'),
                    );
                }
              }),
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
                children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
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

  TvList(this.tvs);

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
                borderRadius: BorderRadius.all(
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
