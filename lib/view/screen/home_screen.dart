import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pcl_viewer/utils/gs.dart';
import 'package:pcl_viewer/view/widget/drop_box.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false; // 변환 중 유무 표시
  bool _dragging = false;
  Offset? offset;

  Future<void> showAlertDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // border
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("PCL파일이 아니에요"),
            content: const Text("PCL 파일만 변환할 수 있어요."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _pickFiles() async {
    try {
      var _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) =>
            debugPrint(status.toString()),
        allowedExtensions: (['pcl']),
      ));
      setState(() {
        _loading = true;
      });
      // for each in _paths
      for (final file in _paths!.files) {
        try {
          if (!file.path!.endsWith(".pcl")) {
            showAlertDialog();
            return;
          }
          final outputFile = "${file.path}.pdf";
          await convertPCLtoPDF(file.path!, outputFile);
          await OpenFile.open(outputFile);
        } catch (exception, stackTrace) {
          await Sentry.captureException(exception, stackTrace: stackTrace);
          debugPrint('Error: $exception');
        }
      }
    } on PlatformException catch (e) {
      debugPrint("Unsupported operation" + e.toString());
    } catch (ex) {
      debugPrint(ex.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropBox(_loading, _pickFiles, showAlertDialog);
  }
}
