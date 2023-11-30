import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  void openInControlView() {
    _navigationService.navigateTo(Routes.manualView);
  }

  void openAutomaticView() {
    _navigationService.navigateTo(Routes.speechView);
  }

  void openFaceTestView() {
    _navigationService.navigateTo(Routes.faceView);
  }
}
