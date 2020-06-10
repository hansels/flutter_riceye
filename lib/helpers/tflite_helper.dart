import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../models/result.dart';
import 'package:tflite/tflite.dart';

import 'app_helper.dart';

class TFLiteHelper {
  static StreamController<List<Result>> tfLiteResultsController =
      StreamController.broadcast();
  static List<Result> _outputs = List();
  static var modelLoaded = false;
  static bool busy = false;

  static Future<String> loadModel() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
      model: "assets/model_baru.tflite",
      labels: "assets/labels.txt",
    );
  }

  static Future<void> classifyImageFromGallery() async {
    var pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    var value = await Tflite.runModelOnImage(
      path: pickedImage.path,
      numResults: 3,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    predict(value);
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
      AppHelper.log("classifyImage", "Results loaded. ${value.length}");

      //Clear previous results
      _outputs.clear();

      value.forEach((element) {
        _outputs.add(
            Result(element['confidence'], element['index'], element['label']));

        AppHelper.log("classifyImage",
            "${element['confidence']} , ${element['index']}, ${element['label']}");
      });
    }

    //Sort results according to most confidence
    _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));

    busy = false;

    //Send results
    tfLiteResultsController.add(_outputs);
  }

  static void disposeModel() {
    Tflite.close();
    tfLiteResultsController.close();
  }

  static Float32List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}
