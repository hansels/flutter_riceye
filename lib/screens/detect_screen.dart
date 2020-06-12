import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riceye/screens/image_screen.dart';
import 'package:flutter_riceye/screens/info_screen.dart';
import '../helpers/camera_helper.dart';
import '../helpers/tflite_helper.dart';
import '../models/result.dart';

class DetectScreen extends StatefulWidget {
  @override
  _DetectScreenPageState createState() => _DetectScreenPageState();
}

class _DetectScreenPageState extends State<DetectScreen> {
  List<Result> outputs;

  void initState() {
    super.initState();

    //Load TFLite Model
    TFLiteHelper.loadModel().then((value) {
      setState(() {
        TFLiteHelper.modelLoaded = true;
      });
    });

    //Initialize Camera
    CameraHelper.initializeCamera();

    //Subscribe to TFLite's Classify events
    TFLiteHelper.tfLiteResultsController.stream.listen((value) {
      //Set Results
      outputs = value;

      //Update results on screen
      setState(() {
        //Set bit to false to allow detection again
        CameraHelper.isDetecting = false;
      });
    }, onDone: () {}, onError: (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: CameraHelper.initializeControllerFuture,
        builder: (context, snapshot) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          if (snapshot.connectionState == ConnectionState.done) {
            final aspectRatio = CameraHelper.camera.value.aspectRatio;
            // If the Future is complete, display the preview.
            return Stack(
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          width: width,
                          height: (height / aspectRatio),
                          child: CameraPreview(CameraHelper.camera),
                        ),
                      ),
                    ),
                  ),
                ),
                TFLiteHelper.buildResultsWidget(width, outputs),
                _title(width, context),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    TFLiteHelper.disposeModel();
    CameraHelper.camera.dispose();
    super.dispose();
  }

  Widget _title(double width, BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(top: topPadding + 16.0),
              child: RawMaterialButton(
                onPressed: () async {
                  await CameraHelper.stopCamera();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InfoScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.info,
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
            Padding(
              padding: EdgeInsets.only(top: topPadding + 16.0),
              child: RawMaterialButton(
                onPressed: () async {
                  await CameraHelper.stopCamera();
                  var file = await TFLiteHelper.classifyImageFromGallery();
                  if (file == null) return await CameraHelper.startCamera();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageScreen(file, outputs),
                    ),
                  );
                },
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 30.0,
                ),
                padding: const EdgeInsets.all(9.0),
                shape: CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
