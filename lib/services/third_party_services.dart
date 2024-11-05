import 'package:injectable/injectable.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/services/api_methods.dart';
import 'package:stacked_services/stacked_services.dart';

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  SnackbarService get snackBarService;
  @lazySingleton
  BottomSheetService get bottomSheetService;
  @lazySingleton
  ApiMethods get apiMethods;
  @lazySingleton
  ApiClient get apiClient;
}
