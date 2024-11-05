import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SuccessViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();


    onLogInButtonClick() {
    navigationService.navigateTo(Routes.loginView);
  }
}
