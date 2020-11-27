library stream_summary_builder;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StreamSummaryBuilder<T, S> extends StreamBuilderBase<T, AsyncSnapshot<S>> {
  const StreamSummaryBuilder({
    Key? key,
    required this.initialSummary,
    this.initialData,
    required this.updateSummary,
    Stream<T>? stream,
    required this.builder,
  }) : super(key: key, stream: stream);

  final SummaryUpdater<T, S> updateSummary;

  final AsyncWidgetBuilder<S> builder;

  final S? initialData;

  final S initialSummary;

  @override
  AsyncSnapshot<S> initial() => initialData == null
      ? AsyncSnapshot<S>.nothing()
      : AsyncSnapshot<S>.withData(ConnectionState.none, initialData as S);

  @override
  AsyncSnapshot<S> afterConnected(AsyncSnapshot<S> current) => current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<S> afterData(AsyncSnapshot<S> current, T data) {
    return AsyncSnapshot<S>.withData(ConnectionState.active, updateSummary(current.data ?? initialSummary, data));
  }

  @override
  AsyncSnapshot<S> afterError(AsyncSnapshot<S> current, Object error) {
    return AsyncSnapshot<S>.withError(ConnectionState.active, error);
  }

  @override
  AsyncSnapshot<S> afterDone(AsyncSnapshot<S> current) => current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<S> afterDisconnected(AsyncSnapshot<S> current) => current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<S> currentSummary) => builder(context, currentSummary);
}

typedef SummaryUpdater<T, S> = S Function(S currentSummary, T newValue);
