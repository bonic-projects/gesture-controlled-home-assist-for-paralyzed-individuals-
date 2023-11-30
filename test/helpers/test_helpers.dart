import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:navigest/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:navigest/services/database_service.dart';
import 'package:navigest/services/stt_service.dart';
import 'package:navigest/services/camera_service.dart';
import 'package:navigest/services/ml_kit_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DatabaseService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SttService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<CameraService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<MlKitService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterDatabaseService();
  getAndRegisterSttService();
  getAndRegisterCameraService();
  getAndRegisterMlKitService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockDatabaseService getAndRegisterDatabaseService() {
  _removeRegistrationIfExists<DatabaseService>();
  final service = MockDatabaseService();
  locator.registerSingleton<DatabaseService>(service);
  return service;
}

MockSttService getAndRegisterSttService() {
  _removeRegistrationIfExists<SttService>();
  final service = MockSttService();
  locator.registerSingleton<SttService>(service);
  return service;
}

MockCameraService getAndRegisterCameraService() {
  _removeRegistrationIfExists<CameraService>();
  final service = MockCameraService();
  locator.registerSingleton<CameraService>(service);
  return service;
}

MockMlKitService getAndRegisterMlKitService() {
  _removeRegistrationIfExists<MlKitService>();
  final service = MockMlKitService();
  locator.registerSingleton<MlKitService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
