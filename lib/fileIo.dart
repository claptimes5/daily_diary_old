import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class FileIo {
  var _directory;

  Future<Directory> get _localDir async {
    _directory ??= await getApplicationDocumentsDirectory();

    return _directory;
  }

  Future<String> get _localPath async {
    return (await _localDir).path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter');
  }

  Future<List<FileSystemEntity>> dirList() async {
    var dir = await _localDir;

    return dir.listSync();
  }
}