import 'package:flutter/material.dart';
import 'recordingList.dart';
import 'recordingScreen.dart';

class RecordingListPage extends StatelessWidget {
  final String title;

  RecordingListPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Flutter'),
      ),
      body: Center(
        child: RecordingsList(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecordingScreen()),
          );
        },
      ),
    );
  }
}
