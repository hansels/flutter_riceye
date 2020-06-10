import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'Riceye',
      theme: ThemeData(
        fontFamily: "Din Pro",
        primaryColor: Color.fromRGBO(225, 205, 119, 1),
        accentColor: Color.fromRGBO(180, 164, 95, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DetectScreen(),
    );
  }
}
