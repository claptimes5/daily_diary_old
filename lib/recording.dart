import 'package:flutter/material.dart';
import 'dart:io';

class Recording extends StatelessWidget {
  Recording({
    Key key,
    this.onPressedButton,
    this.fileOrDir,
    this.isFilePlaying,
    this.child,
  }) : super(key: key);

  final Object fileOrDir;
  final Widget child;
  final bool isFilePlaying;
  final VoidCallback onPressedButton;

  @override
  Widget build(BuildContext context) {
    Widget listItem;

    if (fileOrDir == null) {
      listItem = new ListTile(
          title: Text('Loading'));
    } else {
//      var fileOrDir = recordingsList[index];

      if (fileOrDir is File) {
        listItem = _fileItem(fileOrDir);
      } else if (fileOrDir is Directory) {
        listItem = _directoryItem(fileOrDir);
      }
    }

    return listItem;
  }

  Widget _directoryItem(Directory dir) {
    String _filePath = dir.path.toString();

    return new ListTile(
      trailing: const Icon(Icons.navigate_next),
      title: Text('Directory'),
      subtitle: Text(_filePath),
    );
  }

  Widget _fileItem(File file) {
    String _filePath = file.path.toString();
    String _lastModified = file.lastModifiedSync().toString();
    Icon icon;

    if (isFilePlaying) {
      icon = Icon(Icons.stop);
    } else {
      icon = Icon(Icons.play_circle_outline);
    }

    return new ListTile(
        trailing: icon,
        title: Text(_lastModified),
        subtitle: Text(_filePath),
        onTap: onPressedButton);
  }
}
