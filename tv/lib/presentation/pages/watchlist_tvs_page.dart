import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class WatchlistTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  const WatchlistTvsPage({Key? key}) : super(key: key);

  @override
  _WatchlistTvsPageState createState() => _WatchlistTvsPageState();
}

class _WatchlistTvsPageState extends State<WatchlistTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<WatchlistTvsCubit>().loadWatchlistTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WatchlistTvsCubit>().state;
    if (state is ErrorWatchlistTvsState) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    }
    if (state is LoadedWatchlistTvsState) {
      return ListView.builder(
        itemBuilder: (context, index) {
          final tv = state.tvs[index];
          return TvCard(tv);
        },
        itemCount: state.tvs.length,
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
