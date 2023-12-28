import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:navigest/services/database_service.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/device.dart';

class ManualViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  // final _navigationService = locator<NavigationService>();
  final _dbService = locator<DatabaseService>();

  DeviceReading? get node => _dbService.node;

  @override
  List<DatabaseService> get listenableServices => [_dbService];

  //Device data

  DeviceData _deviceData =
      DeviceData(r1: false, r2: false, r3: false, r4: false, phone: "");

  DeviceData get deviceData => _deviceData;

  void setDeviceData() {
    _dbService.setDeviceData(_deviceData);
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

  void setR1() {
    _deviceData.r1 = !_deviceData.r1;
    notifyListeners();
    setDeviceData();
  }

  void setR2() {
    _deviceData.r2 = !_deviceData.r2;
    notifyListeners();
    setDeviceData();
  }

  void setR3() {
    _deviceData.r3 = !_deviceData.r3;
    notifyListeners();
    setDeviceData();
  }

  void setR4() {
    _deviceData.r4 = !_deviceData.r4;
    notifyListeners();
    setDeviceData();
  }

  void onModelReady() {
    getDeviceData();
  }
}
