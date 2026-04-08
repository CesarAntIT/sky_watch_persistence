import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AssetFileGet {
  static Future<String> getAssetPath(String assetName) async {
    // 1. Get the local documents directory
    final directory = await getApplicationDocumentsDirectory();

    // 2. Create the target file path
    final path = join(directory.path, assetName);
    final file = File(path);

    // 3. Only copy if it doesn't exist (to save performance)
    if (!(await file.exists())) {
      // Load the asset from the bundle
      final byteData = await rootBundle.load('assets/$assetName');

      // Create the file and write the bytes
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
    }

    return file.path;
  }
}
