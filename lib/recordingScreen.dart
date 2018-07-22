import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
//import 'package:fu'

// Recording
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class RecordingScreen extends StatefulWidget {
  @override
  createState() => _RecordingsState();
}

class _RecordingsState extends State<RecordingScreen> {
  bool _hasPermissions;
  bool _isRecording;
  var _fileValue;

  void toggleRecording() async {
    // Check permissions before starting
    var hasPermissions = await AudioRecorder.hasPermissions;

    if (!hasPermissions) {
      bool permissionWrite = await SimplePermissions
          .requestPermission(Permission.WriteExternalStorage);

      if (!permissionWrite) {
        _alertMessage(text: 'no permissions to write');
        return;
      }

      bool permissionRecord =
          await SimplePermissions.requestPermission(Permission.RecordAudio);

      if (!permissionRecord) {
        _alertMessage(text: 'no permissions to record');
        return;
      }
    }

    hasPermissions = await AudioRecorder.hasPermissions;

    // Get the state of the recorder
    var isRecording = await AudioRecorder.isRecording;

    if (!isRecording) {
      _beginRecording();
    } else {
      _endRecording();
    }

    setState(() {
      _hasPermissions = hasPermissions;
      _isRecording = isRecording;
    });
  }

  void _beginRecording() async {
    final localFile = await _localFile;
    final fileExists = await localFile.exists();

    await _createDirectory();

    if (fileExists) {
      localFile.delete();
    }

    // Start recording
    await AudioRecorder.start(
        path: localFile.path.toString(), audioOutputFormat: AudioOutputFormat.AAC);

    var isRecording = await AudioRecorder.isRecording;

    setState(() {
      _isRecording = isRecording;
    });
  }

  Future<Directory> _createDirectory() async {
    final directoryPath = await _localPath;
    final dir = new Directory(directoryPath);
    final dirExists = await dir.exists();

    if (!dirExists) {
      return dir.create(recursive: true);
    }

    return dir;
  }

//    _neverSatisfied(text: localFile.toString());

  Future<Null> _alertMessage({text: String}) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(text),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('You will never be satisfied.'),
                new Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _endRecording() async {
//     Stop recording
    Recording recording = await AudioRecorder.stop();
    print("Path : ${recording.path},  Format : ${recording
        .audioOutputFormat},  Duration : ${recording
        .duration},  Extension : ${recording.extension},");

    var isRecording = await AudioRecorder.isRecording;

    setState(() {
      _isRecording = isRecording;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final now = DateTime.now().toIso8601String();
    return File('$path/diary-$now');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 0;
    }
  }

  void setCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      setState(() {
        _fileValue = int.parse(contents);
      });
    } catch (e) {
      // If we encounter an error, return 0
      setState(() {
        _fileValue = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record your entry for today"),
      ),
      body: new Column(children: <Widget>[
        RaisedButton(
          onPressed: () {
            toggleRecording();

            writeCounter(4);
          },
          child: Text('Record'),
        ),
        Text("Permitted: $_hasPermissions. Recording? $_isRecording"),
        RaisedButton(
          onPressed: () {
            setCounter();
          },
          child: Text('Get Value'),
        ),
        Text("Value: $_fileValue"),
      ]),
    );
  }
}
