import 'package:flutter/material.dart';
import 'recordingListPage.dart';
import 'recordingScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Gesture Demo';

    return MaterialApp(
      title: title,
      home: RecordingListPage(title: title)
//      home: RecordingScreen()
    );
  }
}

//class Recording extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//   return new ListTile(
//     trailing: const Icon(Icons.play_circle_outline),
//     title: const Text('The seat for the narrator'),
//   )
//  }
//}
