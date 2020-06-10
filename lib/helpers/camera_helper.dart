import 'package:camera/camera.dart';

import 'app_helper.dart';
import 'tflite_helper.dart';

class CameraHelper {
  static CameraController camera;

  static bool isDetecting = false;
  static CameraLensDirection _direction = CameraLensDirection.back;
  static Future<void> initializeControllerFuture;

  static Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  static Future<void> startCamera() async {
    await camera.startImageStream((CameraImage image) {
      if (!TFLiteHelper.modelLoaded) return;
      if (isDetecting) return;
      isDetecting = true;
      try {
        TFLiteHelper.classifyImage(image);
      } catch (e) {
        print(e);
      }
    });
  }

  static Future<void> stopCamera() async {
    await camera.stopImageStream();
  }

  static void initializeCamera() async {
    AppHelper.log("_initializeCamera", "Initializing camera..");

    camera = CameraController(
      await _getCamera(_direction),
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    initializeControllerFuture = camera.initialize().then((value) {
      AppHelper.log(
          "_initializeCamera", "Camera initialized, starting camera stream..");
      startCamera();
    });
  }
}
