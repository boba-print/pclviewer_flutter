import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

Future<void> convertPCLtoPDF(String targetFile, String outputFile) async {
  String binaryPath = '';
  String binaryDLL = ''; // For Windows
  if (kReleaseMode) {
    // Production mode
    if (Platform.isMacOS) {
      binaryPath = 'lib/bin/pcl6mac';
    } else if (Platform.isWindows) {
      binaryPath = 'lib/bin/gpcl6win64.exe';
      binaryDLL = 'lib/bin/gpcl6dll64.dll';
    }
  } else {
    // Debug mode
    if (Platform.isMacOS) {
      binaryPath = 'bin/macos/pcl6mac';
    } else if (Platform.isWindows) {
      binaryPath = 'bin/windows/gpcl6win64.exe';
      binaryDLL = 'bin/windows/gpcl6dll64.dll';
    }
  }

  if (binaryPath == '') throw Exception("Unsupported platform");

  final String tempPath = Directory.systemTemp.path;
  File binaryFile;

  if (Platform.isMacOS) {
    final ByteData data = await rootBundle.load(binaryPath);
    final String binaryFileName = path.basename(binaryPath);
    binaryFile = File('$tempPath/$binaryFileName');

    if (!binaryFile.existsSync()) {
      await binaryFile.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      if (Platform.isMacOS) {
        await Process.run('chmod', ['+x', binaryFile.path]);
      }
    }
  } else if (Platform.isWindows) {
    // copy dll
    final ByteData data = await rootBundle.load(binaryPath);
    final String binaryFileName = path.basename(binaryPath);
    binaryFile = File('$tempPath/$binaryFileName');

    final ByteData dataDLL = await rootBundle.load(binaryDLL);
    final String binaryDLLName = path.basename(binaryDLL);
    final File binaryDLLFile = File('$tempPath/$binaryDLLName');

    // Check if both the binary file and the DLL exist, if not, write them
    if (!binaryFile.existsSync() || !binaryDLLFile.existsSync()) {
      await binaryFile.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      await binaryDLLFile.writeAsBytes(dataDLL.buffer
          .asUint8List(dataDLL.offsetInBytes, dataDLL.lengthInBytes));
    }
  } else {
    throw Exception("Unsupported platform");
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
