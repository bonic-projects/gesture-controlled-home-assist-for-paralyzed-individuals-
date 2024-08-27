import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/user_service.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  void openInControlView() {
    _navigationService.navigateTo(Routes.manualView);
  }

  void openSpeechView() {
    _navigationService.navigateTo(Routes.speechView);
  }

  void openAutomaticView() {
    _navigationService.navigateTo(Routes.automaticView);
  }

  void openFaceTestView() {
    _navigationService.navigateTo(Routes.faceView);
  }
}
