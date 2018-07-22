import 'package:flutter/material.dart';
import 'fileIo.dart';
import 'dart:async';
import 'dart:io';

class RecordingsList extends StatefulWidget {
  @override
  createState() => _RecordingsList();
}

class _RecordingsList extends State<RecordingsList> {
  var recordingsList;
  bool listRetrieved = false;

  void retrieveFiles() async {
    var _recordingsList = await (new FileIo()).dirList();

    if (listRetrieved == false) {
      setState(() {
        recordingsList = _recordingsList;
        listRetrieved = true;
      });
    }
  }

  Widget _recording(int index) {
//        final _recordingDate = DateTime.now()
//                .subtract(new Duration(days: index))
//        .toString();
    var _text;

    if (recordingsList[index] == null) {
      _text = "Loading";
    } else if (index < recordingsList.length) {
      var fileOrDir = recordingsList[index];
      String _filePath = fileOrDir.toString();
      String _lastModified;

      for (var fileOrDir in recordingsList) {
        if (fileOrDir is File) {
          _lastModified = fileOrDir.lastModifiedSync().toString();
        } else if (fileOrDir is Directory) {
          print(fileOrDir.path);
        }
      }

      _text = "$_lastModified - $_filePath";
    }

    return new ListTile(
      trailing: const Icon(Icons.play_circle_outline),
      title: Text(_text),
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
      itemExtent: 20.0,
      itemCount: recordingsListLength,
      itemBuilder: (BuildContext context, int index) {
        return _recording(index);
      },
    );
  }
}
