import 'dart:async';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/device.dart';
import '../../../services/database_service.dart';
import '../../../services/stt_service.dart';
import '../../common/app_strings.dart';

class SpeechViewModel extends ReactiveViewModel {
  final log = getLogger('SpeechViewModel');

  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  final _sttService = locator<SttService>();

  String get lastWords => _sttService.lastWords;

  final _dbService = locator<DatabaseService>();

  DeviceReading? get node => _dbService.node;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_sttService, _dbService];

  void onModelReady() async {
    _sttService.initSpeech(onSpeechStatus, onSpeechError);
    getDeviceData();
  }

  bool _isMic = false;

  bool get isMic => _isMic;

  void onSpeechError(SpeechRecognitionError error) {
    log.e("Error");
    log.e(error.errorMsg);
    if (error.errorMsg == "error_no_match") {
      showDialog("Error", "Sorry, can you please repeat?");
    } else if (error.errorMsg == "error_speech_timeout") {
      showDialog("Error", "I don't hear anything");
    } else {
      showDialog(
          "Error",
          error.errorMsg == "error_network"
              ? "Error! Where are we? I don't have a proper internet connection."
              : "Error, Sorry we have am unknown error.");
    }
  }

  void onSpeechStatus(String text) {
    log.i(text);

    if (text == "listening") {
      // log.d("list");
      _isMic = true;
      notifyListeners();
    } else if (text == "notListening") {
      _isMic = false;
      notifyListeners();
    }
    notifyListeners();
  }

  String _inputText = "";

  void onInput(String value) {
    _inputText = value;
  }

  void startListen() {
    voiceCall(true);
  }

  void voiceCall(bool isCall) async {
    _sttService.startListening(onSpeech, _isMalayalam ? 1 : 0);
  }

  void onSpeech(String text, bool isFinish) async {
    if (isFinish) {
      log.i("Finish hearing:");
      log.i(text);
      processText(text);
    } else {
      log.i("ee");
    }
  }

  bool _isMalayalam = false;

  Future<bool> processText(String text) async {
    if (text.contains("light") && text.contains("on")) {
      // _isFollowing = false;
      setR1(value: true);
      return false;
    } else if (text.contains("light") && text.contains("off")) {
      setR1(value: false);
      return false;
    } else if (text.contains("pump") && text.contains("on")) {
      // _isFollowing = false;
      setR2(value: true);
      return false;
    } else if (text.contains("pump") && text.contains("off")) {
      setR2(value: false);
      return false;
    } else if (text.contains("fan") && text.contains("on")) {
      // _isFollowing = false;
      setR3(value: true);
      return false;
    } else if (text.contains("fan") && text.contains("off")) {
      setR3(value: false);
      return false;
    } else if (text.contains("lamp") && text.contains("on")) {
      // _isFollowing = false;
      setR4(value: true);
      return false;
    } else if (text.contains("lamp") && text.contains("off")) {
      setR4(value: false);
      return false;
    } else if (text.contains("call") || text.contains("nurse")) {
      log.i("Calling..");

      callNumber();
      return false;
    } else if (text.contains("Malayalam")) {
      _isMalayalam = true;
      // _ttsService.setLanguage(1);
      // await _ttsService.speak("Ok, ഞാൻ ഇനി മലയാളത്തിൽ സംസാരിക്കാം.");
      return false;
    } else if (text.contains("ഇംഗ്ലീഷ്")) {
      _isMalayalam = false;
      // _ttsService.setLanguage(0);
      // await _ttsService.speak("Ok, now I will speak in english.");
      return false;
    }
    // else if (text.contains("follow") || text.contains("track")) {
    //   _isFollowing = true;
    //   await _ttsService.speak("Ok I will follow your face!");
    //   return false;
    // }

    else {
      return true;
    }
  }

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

  void showDialog(String title, String description) {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: title,
      description: description,
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
}
