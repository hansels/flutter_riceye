import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riceye/configs/configs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/result.dart';
import 'package:tflite/tflite.dart';

class TFLiteHelper {
  static StreamController<List<Result>> tfLiteResultsController =
      StreamController.broadcast();
  static List<Result> _outputs = List();
  static var modelLoaded = false;
  static bool busy = false;

  static Future<String> loadModel() async {
    return Tflite.loadModel(
      model: "assets/model_baru.tflite",
      labels: "assets/labels.txt",
    );
  }

  static Future<File> classifyImageFromGallery() async {
    var pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    var value = await Tflite.runModelOnImage(
      path: pickedImage.path,
      numResults: 3,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    predict(value);
    return pickedImage;
  }

  static Future<void> classifyImage(CameraImage image) async {
    if (busy) return;
    busy = true;
    var value = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      numResults: 3,
      imageHeight: 224,
      imageWidth: 224,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    predict(value);
  }

  static void predict(List<dynamic> value) {
    if (value.isNotEmpty) {
      //Clear previous results
      _outputs.clear();

      value.forEach((element) {
        _outputs.add(
            Result(element['confidence'], element['index'], element['label']));
      });
    }

    //Sort results according to most confidence
    _outputs.sort((a, b) => b.confidence.compareTo(a.confidence));

    busy = false;

    //Send results
    tfLiteResultsController.add(_outputs);
  }

  static void disposeModel() {
    Tflite.close();
    tfLiteResultsController.close();
  }

  static Widget buildResultsWidget(
    double width,
    List<Result> outputs, {
    Color color = Colors.white54,
  }) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 100.0,
          width: width,
          color: color,
          child: outputs != null && outputs.isNotEmpty
              ? ListView.builder(
                  itemCount: outputs.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Text(
                          outputs[index].label,
                          style: TextStyle(
                            color: Configs.tertiaryColor,
                            fontSize: 20.0,
                          ),
                        ),
                        LinearPercentIndicator(
                          width: width * 0.875,
                          lineHeight: 14.0,
                          percent: outputs[index].confidence,
                          progressColor: Configs.tertiaryColor,
                        ),
                        Text(
                          "${(outputs[index].confidence * 100.0).toStringAsFixed(2)} %",
                          style: TextStyle(
                            color: Configs.tertiaryColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    );
                  },
                )
              : const Center(
                  child: Text(
                    "Wating for model to detect..",
                    style: TextStyle(
                      color: Configs.tertiaryColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
