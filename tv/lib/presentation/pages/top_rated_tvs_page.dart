import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/cubit/top_rated_movies/top_rated_tvs_cubit.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class TopRatedTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  const TopRatedTvsPage({Key? key}) : super(key: key);

  @override
  _TopRatedTvsPageState createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedTvsCubit>().loadTopRatedTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tvs'),
      ),
      body: const Padding(
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
    final state = context.watch<TopRatedTvsCubit>().state;
    if (state is ErrorTopRatedTvsState) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    }
    if (state is LoadedTopRatedTvsState) {
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
