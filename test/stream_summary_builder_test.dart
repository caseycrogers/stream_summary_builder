import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stream_summary_builder/stream_summary_builder.dart';

void main() {
  Stream<T> _streamFrom<T>(
    List<T> values, [
    Duration delay = const Duration(milliseconds: 1),
  ]) async* {
    for (final T value in values) {
      await Future.delayed(delay);
      yield value;
    }
  }

  Widget _boilerPlate({
    Stream<int>? stream,
    Key? listViewKey,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: StreamSummaryBuilder<int, List<int>>(
        initialData: [0],
        stream: stream,
        fold: (valuesSoFar, value) {
          return valuesSoFar..add(value);
        },
        builder: (context, valuesSnap) {
          if (!valuesSnap.hasData) {
            return Text('no data');
          }
          return ListView(
            key: listViewKey,
            children: valuesSnap.data!.map((i) => Text(i.toString())).toList(),
          );
        },
      ),
    );
  }

  testWidgets('Can build a list view from stream', (WidgetTester tester) async {
    final Key listViewKey = ValueKey('list_view');
    await tester.pumpWidget(
      _boilerPlate(
        stream: _streamFrom([1, 2]),
        listViewKey: listViewKey,
      ),
    );
    expect(find.text('0'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('2'), findsOneWidget);
    await tester.pumpAndSettle();

    final Finder listViewFinder = find.byKey(listViewKey);
    expect(listViewFinder, findsOneWidget);
    ListView listView = listViewFinder.evaluate().single.widget as ListView;
    expect(listView.childrenDelegate.estimatedChildCount, 3);
  });

  testWidgets('Summary captures events between frames.',
      (WidgetTester tester) async {
    final Key listViewKey = ValueKey('list_view');
    await tester.pumpWidget(
      _boilerPlate(
        stream: _streamFrom([1, 2, 3, 4, 5]),
        listViewKey: listViewKey,
      ),
    );
    expect(find.text('0'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 3));
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('5'), findsOneWidget);

    final Finder listViewFinder = find.byKey(listViewKey);
    expect(listViewFinder, findsOneWidget);
    ListView listView = listViewFinder.evaluate().single.widget as ListView;
    expect(listView.childrenDelegate.estimatedChildCount, 5);
  });
}
