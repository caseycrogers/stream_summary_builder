import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/delayed_text.dart';
import 'package:stream_summary_builder/stream_summary_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<String> _cachedTextStream;

  void _initStream() {
    _cachedTextStream = delayedText();
  }

  @override
  void initState() {
    // Create our stream here to prevent rebuilding the stream on widget
    // rebuilds.
    _initStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Summary Builder Demo',
      home: SafeArea(
        child: Scaffold(
          body: StreamSummaryBuilder<String, String>(
            initialData: '',
            fold: (summary, value) => summary + value,
            /// Simulates receiving text line by line from an asynchronous source
            stream: delayedText(),
            builder: _displayTextSummary
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () => setState(_initStream),
          ),
        ),
      ),
    );
  }

  Widget _displayTextSummary(BuildContext context, AsyncSnapshot<String> snapshot) {
    return Align(child: Text(snapshot.data ?? ''), alignment: Alignment.topLeft);
  }
}
