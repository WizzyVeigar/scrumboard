import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageConnector {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/token.txt');
  }

  Future<void> SetToken(String? token) async {
    File file = await _localFile;
    if (token!.isNotEmpty) file.writeAsString(token);
  }

  Future<AlertDialog> GetToken() async {
    File file = await _localFile;
    String? token = await file.readAsString();
    return AlertDialog(
      title: const Text('Token Dialog'),
      content:
          Text('Your Token : ${token.isEmpty ? 'could not be read' : token}'),
    );
  }
}
