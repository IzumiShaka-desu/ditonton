import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/cubit/popular_tvs/popular_tvs_cubit.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class PopularTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  const PopularTvsPage({Key? key}) : super(key: key);

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularTvsCubit>().loadPopularTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tvs'),
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
    final state = context.watch<PopularTvsCubit>().state;
    if (state is ErrorPopularTvsState) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    }
    if (state is LoadedPopularTvsState) {
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
