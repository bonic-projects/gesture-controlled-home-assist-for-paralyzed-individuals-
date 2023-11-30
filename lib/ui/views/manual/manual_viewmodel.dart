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
      DeviceData(r1: false, r2: false, r3: false, r4: false);
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
      );
    } else {
      _deviceData = DeviceData(r1: false, r2: false, r3: false, r4: false);
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
