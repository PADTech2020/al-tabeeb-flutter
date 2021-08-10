import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart' as path;

class FileUtil {
  Future<File> getFileFromByteData(ByteData bytes, {String fileName}) async {
    if (fileName == null) fileName = DateTime.now().toIso8601String();
    String dir = (await path.getTemporaryDirectory()).path;
    return await writeToFile(bytes, '$dir/$fileName');
  }

  //write to app path
  Future<File> writeToFile(ByteData data, String path) {
    log('////image file Path : $path');
    final buffer = data.buffer;
    return new File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<FileSystemEntity> deleteFile(String path) {
    try {
      return File(path).delete(recursive: false);
    } catch (error) {
      rethrow;
    }
  }

  Future<FileSystemEntity> deleteFile2(File file) async {
    try {
      return await file.delete(recursive: false);
    } catch (error) {
      rethrow;
    }
  }
}
