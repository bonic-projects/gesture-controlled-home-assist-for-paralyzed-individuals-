import 'package:navigest/services/camera_service.dart';
import 'package:navigest/services/database_service.dart';
import 'package:navigest/services/ml_kit_service.dart';
import 'package:navigest/services/stt_service.dart';
import 'package:navigest/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:navigest/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:navigest/ui/views/automatic/automatic_view.dart';
import 'package:navigest/ui/views/face/face_view.dart';
import 'package:navigest/ui/views/home/home_view.dart';
import 'package:navigest/ui/views/manual/manual_view.dart';
import 'package:navigest/ui/views/speech/speech_view.dart';
import 'package:navigest/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/firestore_service.dart';
import '../services/user_service.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/login_register/login_register_view.dart';
import '../ui/views/register/register_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: ManualView),
    MaterialRoute(page: SpeechView),
    MaterialRoute(page: FaceView),
    MaterialRoute(page: AutomaticView),
    MaterialRoute(page: LoginRegisterView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: SttService),
    LazySingleton(classType: CameraService),
    LazySingleton(classType: MlKitService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),
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
