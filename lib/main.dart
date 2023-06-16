import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pcl_viewer/top_bar.dart';
import 'package:pcl_viewer/utils/gs.dart';
import 'package:pcl_viewer/view/screen/home_screen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(600, 600),
    center: true,
    backgroundColor: Colors.white,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  final startFile = await getStartFile(args);
  await SentryFlutter.init(
    (options) {
      options.dsn = "https://0b1a424e713c4cdea9d1d9d498fb3de6@o4505362080137216.ingest.sentry.io/4505362080792576";
    },
    appRunner: () => runApp(MainApp(startFile)),
  );
}

Future<String> getStartFile(List<String> args) async {
  if (args.isNotEmpty) return args.first;
  if (Platform.isMacOS) {
    // in MacOS, we need to make a call to Swift native code to check if a file has been opened with our App
    const hostApi = MethodChannel("pclViewer");
    final String? currentFile = await hostApi.invokeMethod("getCurrentFile");
    if (currentFile != null) return currentFile;
  }
  return "";
}

class MainApp extends StatefulWidget {
  String filePath;
  MainApp(this.filePath, {super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    convertIfAvailable();
  }

  void convertIfAvailable() async {
    try {
      if (widget.filePath.isEmpty) return;
      var file = File(widget.filePath);
      if (!file.path.endsWith(".pcl")) return;
      var path = file.path;
      var outputFile = "${path.substring(0, path.length - 4)}.pdf";
      await convertPCLtoPDF(file.path, outputFile);
      await OpenFile.open(outputFile);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(children: const [
          TopBar(),
          Center(
              child: SizedBox(
            width: 550,
            height: 500,
            child: HomeScreen(),
          )),
        ]),
      ),
    );
  }
}
