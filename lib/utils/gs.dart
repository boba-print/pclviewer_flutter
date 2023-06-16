import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

Future<void> convertPCLtoPDF(String targetFile, String outputFile) async {
  String binaryPath = '';

  if (kReleaseMode) {
    // Production mode
    if (Platform.isMacOS) {
      binaryPath = 'lib/bin/pcl6mac';
    } else if (Platform.isWindows) {
      binaryPath = 'lib/bin/gpcl6win64.exe';
    }
  } else {
    // Debug mode
    if (Platform.isMacOS) {
      binaryPath = 'bin/macos/pcl6mac';
    } else if (Platform.isWindows) {
      binaryPath = 'bin/windows/gpcl6win64.exe';
    }
  }

  if (binaryPath == '') throw Exception("Unsupported platform");

  final ByteData data = await rootBundle.load(binaryPath);
  final String tempPath = Directory.systemTemp.path;
  // Use only the file name for the temporary file.
  final String binaryFileName = path.basename(binaryPath);
  final File binaryFile = File('$tempPath/$binaryFileName');

  if (!binaryFile.existsSync()) {
    await binaryFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    if (Platform.isMacOS) {
      await Process.run('chmod', ['+x', binaryFile.path]);
    }
  }

  await Process.run(binaryFile.path, [
    "-dNOPAUSE",
    "-dQUIET",
    "-dBATCH",
    "-dEmbedAllFonts=true",
    "-sDEVICE=pdfwrite",
    "-sOutputFile=$outputFile",
    targetFile,
  ]);
}
