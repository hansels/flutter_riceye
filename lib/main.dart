import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riceye/configs/configs.dart';
import 'package:flutter_riceye/screens/detect_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Configs.appName,
      theme: ThemeData(
        fontFamily: "Din Pro",
        primaryColor: Configs.primaryColor,
        accentColor: Configs.secondaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DetectScreen(),
    );
  }
}
