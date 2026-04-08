import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImgPickService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String> addImage(String imagePath) async {
    if (imagePath.isNotEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'sky_watch_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final localPath = join(dir.path, fileName);

      await File(imagePath).copy(localPath);

      return localPath;
    } else {
      return "";
    }
  }

  static Future<String> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return "";
  }

  static void deleteImage(String imagePath) {
    final file = File(imagePath);

    if (file.existsSync()) {
      try {
        file.deleteSync();
      } catch (e) {
        debugPrint("No se pudo eliminar el archivo: $e");
      }
    }
  }

  static void deleteAllImages() async {
    try {
      // 1. Get the local documents directory
      final directory = await getApplicationDocumentsDirectory();

      // 2. List all files in that directory
      final List<FileSystemEntity> files = directory.listSync();

      // 3. Define the image extensions you want to target
      final imageExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

      for (FileSystemEntity file in files) {
        if (file is File) {
          // Check if the file extension matches our image list
          String path = file.path.toLowerCase();
          if (imageExtensions.any((ext) => path.endsWith(ext))) {
            await file.delete();
            debugPrint("Deleted: ${file.path}");
          }
        }
      }
      debugPrint("All images deleted.");
    } catch (e) {
      debugPrint("Error deleting images: $e");
    }
  }
}
