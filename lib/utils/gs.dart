import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> copyBinary() async {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;

  if(Platform.isMacOS){
    final ByteData data = await rootBundle.load('bin/macOS/pcl6mac');
    final String tempPath = Directory.systemTemp.path;
    final File binaryFile = File('$tempPath/pcl6mac');
    debugPrint(binaryFile.path);

    await binaryFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    await Process.run('chmod', ['+x', binaryFile.path]);
    prefs.setString("binaryPath", binaryFile.path);
    return binaryFile.path;
  }else if(Platform.isWindows){
    final ByteData data = await rootBundle.load('bin/windows/gpcl6win64.exe');
    final String tempPath = Directory.systemTemp.path;
    final File binaryFile = File('$tempPath/gpcl6win64.exe');

    final ByteData dataDLL = await rootBundle.load('bin/windows/gpcl6dll64.dll');
    final String tempPathDLL = Directory.systemTemp.path;
    final File binaryFileDLL = File('$tempPath/gpcl6dll64.dll');

    debugPrint(binaryFile.path);

    await binaryFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    await binaryFileDLL.writeAsBytes(
        dataDLL.buffer.asUint8List(dataDLL.offsetInBytes, dataDLL.lengthInBytes));

    prefs.setString("binaryPath", binaryFile.path);
    return binaryFile.path;
  }
  else if(Platform.isLinux){
    final ByteData data = await rootBundle.load('bin/pcl6linux');
    final String tempPath = Directory.systemTemp.path;
    final File binaryFile = File('$tempPath/pcl6linux');
    debugPrint(binaryFile.path);

    await binaryFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    prefs.setString("binaryPath", binaryFile.path);
    return binaryFile.path;
  }
  else{
    throw Exception("Unsupported platform");
  }
}

Future<String> getBinaryPath() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  final String? binaryPath = prefs.getString("binaryPath");
  if (binaryPath != null) {
    return binaryPath;
  } else {
    return await copyBinary();
  }
}

Future<void> convertPCLtoPDF(String targetFile, String outputFile) async {
  final binaryPath = await getBinaryPath();
  File file = File(binaryPath);
  if(!file.existsSync()){
    await copyBinary();
  }
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
