import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riceye/helpers/tflite_helper.dart';
import '../helpers/camera_helper.dart';
import '../models/result.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen(this.file, this.outputs);

  final File file;
  final List<Result> outputs;

  @override
  _ImageScreenPageState createState() => _ImageScreenPageState();
}

class _ImageScreenPageState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                child: Image.file(
                  widget.file,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          TFLiteHelper.buildResultsWidget(
            width,
            widget.outputs,
            color: Colors.white70,
          ),
          _title(width, context),
        ],
      ),
    );
  }

  Widget _title(double width, BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding + 16.0),
            child: RawMaterialButton(
              onPressed: () async {
                await CameraHelper.startCamera();
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30.0,
              ),
              padding: const EdgeInsets.all(9.0),
              shape: CircleBorder(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topPadding + 16.0),
            child: Text(
              "RICEYE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
