import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:stacked/stacked.dart';

import '../app/app.logger.dart';
import '../ui/widgets/painters/face_detector_painter.dart';

class MlKitService with ListenableServiceMixin {
  final log = getLogger('MlKitService');

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableTracking: true,
      enableClassification: true,
    ),
  );

  final bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  bool _isFace = false;
  final _cameraLensDirection = CameraLensDirection.front;

  bool get isBusy => _isBusy;

  CustomPaint? get customPaint => _customPaint;

  String? get text => _text;

  bool get isFaceDetected => _isFace;

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    notifyListeners();
    // setState(() {
    //   _text = '';
    // });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );

      _faceTranslator(faces);

      _customPaint = CustomPaint(painter: painter);
      _text = 'Faces found: ${faces.length}\n\n';
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    notifyListeners();
    // if (mounted) {
    //   setState(() {});
    // }
  }

  double _xPos = 0;

  double get xPos => _xPos;
  double _yPos = 0;

  double get yPos => _yPos;
  double _faceSize = 0;

  double? get leftEyeOpen => _leftEye;
  double? _leftEye = 0;

  double? get rightEyeOpen => _rightEye;
  double? _rightEye = 0;

  double? get smile => _smile;
  double? _smile = 0;

  double get faceSize => _faceSize;

  bool _isFaceDetect = false;

  void _faceTranslator(
    List<Face> faces,
  ) {
    if (faces.isNotEmpty) {
      _isFace = true;
      // log.i(("Face: ${faces[0].smilingProbability != null ? faces[0].smilingProbability! * 100 : null}"));
      _leftEye = faces[0].leftEyeOpenProbability != null
          ? faces[0].leftEyeOpenProbability! * 100
          : null;
      _smile = faces[0].smilingProbability != null
          ? faces[0].smilingProbability! * 100
          : null;
      _rightEye = faces[0].rightEyeOpenProbability != null
          ? faces[0].rightEyeOpenProbability! * 100
          : null;
      double x = mapValue(faces[0].boundingBox.center.dx, 0, 100, -40, 40);
      double y = mapValue(faces[0].boundingBox.center.dy, 0, 100, -40, 40);
      _faceSize = faces[0].boundingBox.height;
      // logger.i(("X: $x, Y: $y"));
      _xPos = x;
      _yPos = y;
    } else {
      _isFace = false;
      _isFaceDetect = false;
      _xPos = 0;
      _yPos = 0;
      _faceSize = 0;
    }
  }

  double mapValue(
      double value, double min1, double max1, double min2, double max2) {
    return ((value - min1) / (max1 - min1)) * (max2 - min2) + min2;
  }
}
