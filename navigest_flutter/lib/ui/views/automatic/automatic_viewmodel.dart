import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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

class AutomaticViewModel extends ReactiveViewModel {
  final log = getLogger('AutomaticViewModel');

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
    getDeviceData();
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
    processFace();
  }

  double get xPos => _mlKitService.xPos;

  double get yPos => _mlKitService.yPos;

  int _count = 0;

  int get count => _count;

  late DateTime lastUpdatedOn;

  bool _isEyesOpen = false;

  DateTime _lastUpdatedOnIndex = DateTime.now();

  void processFace() {
    // Check xPos for left/right control
    if (leftEyeOpenProb != null &&
        leftEyeOpenProb! < 35 &&
        rightEyeOpenProb != null &&
        rightEyeOpenProb! < 35 &&
        _isEyesOpen) {
      _isEyesOpen = false;
      DateTime now = DateTime.now();
      // log.i(lastUpdatedOn);
      // log.i(now);
      // log.i(now.difference(lastUpdatedOn).inMilliseconds);
      // log.i(lastUpdatedOn.difference(now).inMilliseconds > 100);
      if (now.difference(lastUpdatedOn).inMilliseconds > 700) { // 500 to 1500
        lastUpdatedOn = now;
        _count++;
        if (_count > 3) {
          _isEnable = true;
          _count = 0;
        }
        if (_isEnable) {
          control(_selectionIndex);
        }
        notifyListeners();
      }
    }





    ///========================
    else if (leftEyeOpenProb != null &&
        leftEyeOpenProb! < 55 &&
        _isEyesOpen) {
      DateTime now = DateTime.now();
      if (now.difference(_lastUpdatedOnIndex).inMilliseconds > 700 &&
          _selectionIndex < 5 &&
          _isEnable) {
        _lastUpdatedOnIndex = now;
        _selectionIndex++;
        notifyListeners();
      }
    } else if (rightEyeOpenProb != null &&
        rightEyeOpenProb! < 50 &&
        _isEyesOpen) {
      DateTime now = DateTime.now();

      if (now.difference(_lastUpdatedOnIndex).inMilliseconds > 700 &&
          _selectionIndex > 0 &&
          _isEnable) {
        _lastUpdatedOnIndex = now;

        _selectionIndex--;
        notifyListeners();
      }
    }

    ///================
    else {
      _isEyesOpen = true;
    }
  }

  //===========================
  bool _isEnable = false;

  bool get isEnable => _isEnable;

  void disable() {
    _isEnable = true;
    notifyListeners();

    _isEnable = false;
    notifyListeners();
  }

  int _selectionIndex = 0;

  int get selectionIndex => _selectionIndex;

  void control(int index) {
    if (index == 0) {
      setR1();
    } else if (index == 1) {
      setR2();
    } else if (index == 2) {
      setR3();
    } else if (index == 3) {
      setR4();
    } else if (index == 4) {
      callNumber();
    } else if (index == 5) {
      disable();
    }
  }

  ///===========================================

  int _camId = 0;

  int get camId => _camId;

  void switchCam() async {
    int? id = camController!.description.lensDirection.index;
    _camId = id == 0 ? 1 : 0;
    log.i("Camera id: $_camId");
    _cameraFeedReady = false;
    notifyListeners();
    await _cameraService.stopLiveFeed();
    _cameraService.initialize(true, getInputImage, onCameraFeedReady,
        id == 0 ? CameraLensDirection.back : CameraLensDirection.front);
    notifyListeners();
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

  bool _isCalling = false;

  bool get isCalling => _isCalling;

  callNumber() async {
    String number = _deviceData.phone; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    _isCalling = res ?? false;
    notifyListeners();
    Future.delayed(const Duration(seconds: 100));
    _isCalling = false;
    notifyListeners();
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
