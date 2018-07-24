import 'package:flutter/material.dart';
import 'fileIo.dart';
import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'audioPlayer.dart';
import 'recording.dart';

class RecordingsList extends StatefulWidget {
  @override
  createState() => _RecordingsList();
}

class _RecordingsList extends State<RecordingsList> {
  var recordingsList;
  bool listRetrieved = false;
  File filePlaying;
  AudioPlayer audioPlugin;

  _RecordingsList() {
    audioPlugin = new AudioPlayer();
  }


  void retrieveFiles() async {
    var _recordingsList = await (new FileIo()).dirList();

    if (listRetrieved == false) {
      setState(() {
        recordingsList = _recordingsList;
        listRetrieved = true;
      });
    }
  }

  Future<void> play(path) async {
    await audioPlugin.play(path, isLocal: true);
  }

  Future<void> stop() async {
    await audioPlugin.stop();
  }

  Widget _handleTap() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => AudioApp()),
//    );
//    play(path);

    return new SimpleDialog(
      title: const Text('Select assignment'),
      children: <Widget>[
        new AudioApp(),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    retrieveFiles();

    int recordingsListLength = 0;
    if (recordingsList != null) {
      recordingsListLength = recordingsList.length;
    }

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
            }
        );
      },
    );
  }
}
