import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starte_kit/core/logger/logger.dart';

export 'storage.dart' hide Storage;

abstract class Storage {
  static Future<String> get internalStoragePath async {
    final internalStorage = await getApplicationDocumentsDirectory();
    return internalStorage.path;
  }

  static Future<bool> extractZipFile(String archiveFile,
      {String? filePath}) async {
    try {
      final String path = filePath ?? await internalStoragePath;
      final List<int> bytes = File('$path/$archiveFile').readAsBytesSync();
      final Archive archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('$path/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          await Directory('$path/$filename').create(recursive: true);
        }
      }
    } catch (error) {
      logger.e('ERROR extractZipFiles: $archiveFile', error: error);
      return false;
    }
    return true;
  }

  /// Hàm đọc Json File
  static Future<Map<String, dynamic>?> readJsonFile(String jsonFile,
      {String? filePath}) async {
    Map<String, dynamic>? jsonMap;
    final String path = filePath ?? await internalStoragePath;
    final file = File('$path/$jsonFile');
    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      jsonMap = jsonDecode(jsonString);
    }
    return jsonMap;
  }
}
