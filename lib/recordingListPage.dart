import 'package:flutter/material.dart';

//import 'recordingList.dart';
import 'recordingScreen.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:io';
import 'dart:async';
import 'recording.dart';
import 'fileIo.dart';

class RecordingListPage extends StatefulWidget {
  @override
  _RecordingListPageState createState() => _RecordingListPageState();
}

class _RecordingListPageState extends State<RecordingListPage> {
  final String title = 'Diary App';

  var recordingsList;
  bool listRetrieved = false;
  File filePlaying;
  AudioPlayer audioPlugin;
  int recordingsListLength = 0;

  _RecordingListPageState() {
    audioPlugin = new AudioPlayer();
  }

  @override
  void initState() {
    super.initState();
//    random = Random();
    retrieveFiles();
  }

  void retrieveFiles() async {
    var _recordingsList = await (new FileIo()).dirList();

    print("test");
//    if (listRetrieved == false) {
      setState(() {
        recordingsList = _recordingsList;
        listRetrieved = true;

        if (recordingsList != null) {
          recordingsListLength = recordingsList.length;
        }
      });
//    }
  }

  Future<void> play(path) async {
    await audioPlugin.play(path, isLocal: true);
  }

  Future<void> stop() async {
    await audioPlugin.stop();
  }

//  Widget _handleTap() {
////    Navigator.push(
////      context,
////      MaterialPageRoute(builder: (context) => AudioApp()),
////    );
////    play(path);
//
//    return new SimpleDialog(
//      title: const Text('Select assignment'),
//      children: <Widget>[
//        new AudioApp(),
//      ],
//    );
//  }

  Widget RecordingsList() {
    return new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemExtent: 60.0,
      itemCount: recordingsListLength,
      itemBuilder: (BuildContext context, int index) {
        return Recording(
            fileOrDir: recordingsList[index],
            isFilePlaying: (recordingsList[index] == filePlaying),
            onPressedButton: () {
              setState(() {
                // Stop playing if already playing
                if (filePlaying == recordingsList[index]) {
                  stop();
                  filePlaying = null;
                } else {
                  filePlaying = recordingsList[index];
                  play(filePlaying.path);
                }
              });
            });
      },
    );
  }

  _navigateAndRecord(BuildContext context) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordingScreen()),
    );

    if (result == 'true') {
// After the Selection Screen returns a result, show it in a Snackbar!
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("$result")));
      retrieveFiles();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('no')));
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => {},
          ),
        ],
      ),
      body: Center(
        child: RecordingsList(),
      ),
      floatingActionButton: new Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return FloatingActionButton(
            tooltip: 'Add', // used by assistive technologies
            child: Icon(Icons.add),
            onPressed: () {
              _navigateAndRecord(context);
            },
          );
        }
      ),
    );
  }
}
