import 'dart:io';
import 'package:flutter/foundation.dart';

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

  await Process.run(binaryPath, [
    "-dNOPAUSE",
    "-dQUIET",
    "-dBATCH",
    "-dEmbedAllFonts=true",
    "-sDEVICE=pdfwrite",
    "-sOutputFile=$outputFile",
    targetFile,
  ]);
}
