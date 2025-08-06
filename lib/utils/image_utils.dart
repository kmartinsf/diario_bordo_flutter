import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<File> compressImage(File imageFile, {int quality = 85}) async {
  final tempDir = await getTemporaryDirectory();
  final targetPath = p.join(
    tempDir.path,
    'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  final compressedFile = await FlutterImageCompress.compressAndGetFile(
    imageFile.path,
    targetPath,
    quality: quality,
    format: CompressFormat.jpeg,
  );

  if (compressedFile == null) {
    throw Exception('Falha ao comprimir imagem');
  }

  return File(compressedFile.path);
}

