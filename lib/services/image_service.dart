import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from either camera or gallery and copies it to local app docs dir
  Future<String?> pickAndSaveImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'product_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}${p.extension(pickedFile.path).isEmpty ? '.jpg' : p.extension(pickedFile.path)}';
      final savedFile = File(p.join(imagesDir.path, fileName));
      await File(pickedFile.path).copy(savedFile.path);

      return savedFile.path;
    } catch (e) {
      debugPrint('Error picking or saving image: $e');
      return null;
    }
  }
}

void debugPrint(String message) {
  // ignore: avoid_print
  print('[ImageService] $message');
}
