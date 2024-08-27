import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/device.dart';
import '../../../services/camera_service.dart';
import '../../../services/database_service.dart';
import '../../../services/ml_kit_service.dart';
import '../../common/app_strings.dart';

class FaceViewModel extends ReactiveViewModel {
  final log = getLogger('FaceViewModel');

  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  final _cameraService = locator<CameraService>();
  final _mlKitService = locator<MlKitService>();
  final _dbService = locator<DatabaseService>();

  DeviceReading? get node => _dbService.node;

  CameraController? get camController => _cameraService.cameraController;

  bool get busyProcessing => _mlKitService.isBusy;

  String? get faceText => _mlKitService.text;

  double? get leftEyeOpenProb => _mlKitService.leftEyeOpen;

  double? get rightEyeOpenProb => _mlKitService.rightEyeOpen;

  double? get smile => _mlKitService.smile;

  CustomPaint? get customPaint => _mlKitService.customPaint;

  @override
  List<ListenableServiceMixin> get listenableServices => [_mlKitService];

  Timer? periodicTimer;

  void onModelReady() async {
    _cameraService.initialize(
        true, getInputImage, onCameraFeedReady, CameraLensDirection.front);
    lastUpdatedOn = DateTime.now();
  }

  bool _cameraFeedReady = false;

  bool get cameraFeedReady => _cameraFeedReady;

  void onCameraFeedReady() {
    log.i("Camera feed ready!");
    _cameraFeedReady = true;
    notifyListeners();
  }

  bool get isFaceDetected => _mlKitService.isFaceDetected;

  void getInputImage(InputImage inputImage) {
    // logger.i("Processing.. ${inputImage.metadata?.size}, ${inputImage.metadata?.rotation}");
    _mlKitService.processImage(inputImage);
    if (_isFollowing) processFaceAndMove();
  }

  double get xPos => _mlKitService.xPos;

  double get yPos => _mlKitService.yPos;

  final bool _isFollowing = true;

  int _count = 0;

  int get count => _count;

  late DateTime lastUpdatedOn;

  void processFaceAndMove() {
    // Check xPos for left/right control
    if (leftEyeOpenProb != null &&
        leftEyeOpenProb! < 30 &&
        rightEyeOpenProb != null &&
        rightEyeOpenProb! < 60) {
      DateTime now = DateTime.now();
      // log.i(lastUpdatedOn);
      // log.i(now);
      // log.i(now.difference(lastUpdatedOn).inMilliseconds);
      // log.i(lastUpdatedOn.difference(now).inMilliseconds > 100);
      if (now.difference(lastUpdatedOn).inMilliseconds > 500) {
        lastUpdatedOn = now;
        _count++;
        notifyListeners();
      }

      if (_count == 2) {
        setR2(value: true);
      } else if (_count == 4) {
        setR2(value: false);
        _count = 0;
      }
    } else if (leftEyeOpenProb != null && leftEyeOpenProb! < 20) {
      setR1(value: true);
    } else if (rightEyeOpenProb != null && rightEyeOpenProb! < 40) {
      setR1(value: false);
    }
  }

  void switchCam() {
    int? id = camController!.cameraId;
    log.i("Camera id: $id");
  }

  //=====================================================
  DeviceData _deviceData =
      DeviceData(r1: false, r2: false, r3: false, r4: false, phone: "");

  DeviceData get deviceData => _deviceData;

  void setDeviceData() {
    _dbService.setDeviceData(_deviceData);
  }

  void getDeviceData() async {
    setBusy(true);
    DeviceData? deviceData = await _dbService.getDeviceData();
    if (deviceData != null) {
      _deviceData = DeviceData(
        r1: deviceData.r1,
        r2: deviceData.r2,
        r3: deviceData.r3,
        r4: deviceData.r4,
        phone: deviceData.phone,
      );
    } else {
      _deviceData =
          DeviceData(r1: false, r2: false, r3: false, r4: false, phone: "");
    }
    setBusy(false);
  }

  void setR1({bool? value}) {
    _deviceData.r1 = value ?? !_deviceData.r1;
    notifyListeners();
    setDeviceData();
  }

  void setR2({bool? value}) {
    _deviceData.r2 = value ?? !_deviceData.r2;
    notifyListeners();
    setDeviceData();
  }

  void setR3({bool? value}) {
    _deviceData.r3 = value ?? !_deviceData.r3;
    notifyListeners();
    setDeviceData();
  }

  void setR4({bool? value}) {
    _deviceData.r4 = value ?? !_deviceData.r4;
    notifyListeners();
    setDeviceData();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  @override
  void dispose() {
    _cameraService.stopLiveFeed();
    super.dispose();
  }
}
