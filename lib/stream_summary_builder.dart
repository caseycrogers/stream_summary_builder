library stream_summary_builder;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// An implementation of [StreamBuilderBase] that folds new stream events into a
/// summary and builds with the summary of stream events seen so far.
///
/// Use this class instead of [StreamBuilder] if you need a widget that
/// represents the summary of all stream event so far instead of just the latest
/// element. A common use case would be building a [ListView] with elements
/// fetched asynchronously from a paginated Database Query.
///
///
/// `T` is the type of stream events.
///
/// `S` is the type of interaction summary. Summaries are wrapped in
/// [AsyncSnapshot] to give the builder access to the [ConnectionState].
///
/// See also:
///  * [StreamBuilder], which is specialized for the case where only the most
///    recent interaction is needed for widget building.
///  * [StreamBuilderBase], an abstract class that enables greater customization
///    of summary and connection state behavior.
class StreamSummaryBuilder<T, S>
    extends StreamBuilderBase<T, AsyncSnapshot<S>> {
  const StreamSummaryBuilder({
    Key? key,
    required this.initialData,
    required this.fold,
    Stream<T>? stream,
    required this.builder,
  }) : super(key: key, stream: stream);

  final Fold<T, S> fold;

  final AsyncWidgetBuilder<S> builder;

  final S initialData;

  @override
  AsyncSnapshot<S> initial() =>
      AsyncSnapshot<S>.withData(ConnectionState.none, initialData);

  @override
  AsyncSnapshot<S> afterConnected(AsyncSnapshot<S> current) =>
      initial().inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<S> afterData(AsyncSnapshot<S> current, T data) {
    return AsyncSnapshot<S>.withData(
        ConnectionState.active, fold(current.data!, data));
  }

  @override
  AsyncSnapshot<S> afterError(
      AsyncSnapshot<S> current, Object error, StackTrace stackTrace) {
    return AsyncSnapshot<S>.withError(ConnectionState.active, error);
  }

  @override
  AsyncSnapshot<S> afterDone(AsyncSnapshot<S> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<S> afterDisconnected(AsyncSnapshot<S> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<S> currentSummary) =>
      builder(context, currentSummary);
}

/// A function that takes a summary and a new value and returns a new summary
/// updated with the new value.
///
/// Examples:
///  * Update a list by appending strings to it:
///    `(lst, newString) => List.from(lst)..add(newString);`
///  * Update a running average of integers:
///    ```class RunningAverage {
///      final double? average;
///      final int n;
///
///      RunningAverage({this.average : 0, required this.n});
///
///      RunningAverage updated(int newVal) =>
///          RunningAverage(average: ((average ?? 0)*n + newVal) / (n + 1), n: n + 1);
///    }
///    .
///    .
///    .
///    (avg, newVal) => avg.updated(newVal);
///    ```
typedef Fold<T, S> = S Function(S currentSummary, T newValue);
