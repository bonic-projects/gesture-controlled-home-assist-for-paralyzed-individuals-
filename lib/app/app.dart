import 'package:navigest/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:navigest/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:navigest/ui/views/home/home_view.dart';
import 'package:navigest/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:navigest/services/database_service.dart';
import 'package:navigest/ui/views/manual/manual_view.dart';
import 'package:navigest/services/stt_service.dart';
import 'package:navigest/services/camera_service.dart';
import 'package:navigest/services/ml_kit_service.dart';
import 'package:navigest/ui/views/speech/speech_view.dart';
import 'package:navigest/ui/views/face/face_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: ManualView),
    MaterialRoute(page: SpeechView),
    MaterialRoute(page: FaceView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: SttService),
    LazySingleton(classType: CameraService),
    LazySingleton(classType: MlKitService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
