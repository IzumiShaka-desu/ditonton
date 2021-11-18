import 'package:core/core.dart';
import 'package:flutter/material.dart';

class StateWidget extends StatelessWidget {
  const StateWidget(
      {Key? key,
      required this.state,
      required this.message,
      required this.child})
      : super(key: key);
  final RequestState state;
  final String message;
  final Widget Function(BuildContext context) child;
  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RequestState.Error:
        return Tooltip(
          message: 'error message',
          child: Center(
            child: Text(message),
          ),
        );
      case RequestState.Empty:
        return Tooltip(
          message: 'data empty',
          child: SizedBox(),
        );
      case RequestState.Loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      case RequestState.Loaded:
        return child(context);
    }
  }
}
