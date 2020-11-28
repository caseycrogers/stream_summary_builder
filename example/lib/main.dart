import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/delayed_text.dart';
import 'package:stream_summary_builder/stream_summary_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Summary Builder Demo',
      home: SafeArea(
        child: Scaffold(
          body: StreamSummaryBuilder<String, String>(
            initialData: '',
            fold: (summary, value) => summary + value,
            /// Simulates receiving text line by line from an aysnchronous source
            stream: delayedText(),
            builder: _displayTextSummary
          ),
        ),
      ),
    );
  }

  Widget _displayTextSummary(BuildContext context, AsyncSnapshot<String> snapshot) {
    return Align(child: Text(snapshot.data ?? ''), alignment: Alignment.topLeft);
  }
}
