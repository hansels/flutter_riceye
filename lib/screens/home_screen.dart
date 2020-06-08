import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CameraDescription> _cameras;
  ImagePicker _imagePicker = ImagePicker();
  String _model;
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;
  CameraController controller;

  List _recognitions;

  @override
  Future<void> initState() async {
    _cameras = await availableCameras();
    _model = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/dict.txt",
      numThreads: 1,
      isAsset: true,
    );
    controller = CameraController(_cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riceye"),
      ),
      body: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ],
      ),
    );
  }

  Future<void> selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  predictImage(File image) {
    if (image == null) return;

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageHeight = info.image.height.toDouble();
            _imageWidth = info.image.width.toDouble();
          });
        })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  Future<void> model(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: _model,
      imageMean: 0.0,
      imageStd: 255.0,
      threshold: 0.2,
      numResultsPerClass: 1,
      asynch: true,
    );

    setState(() {
      _recognitions = recognitions;
    });
  }
}
