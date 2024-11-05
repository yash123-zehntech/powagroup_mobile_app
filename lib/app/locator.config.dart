// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i6;

import '../services/api.dart' as _i3;
import '../services/api_client.dart' as _i4;
import '../services/api_methods.dart' as _i5;
import '../services/third_party_services.dart' as _i7;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.Api>(() => _i3.Api());
  gh.lazySingleton<_i4.ApiClient>(() => thirdPartyServicesModule.apiClient);
  gh.lazySingleton<_i5.ApiMethods>(() => thirdPartyServicesModule.apiMethods);
  gh.lazySingleton<_i6.BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  gh.lazySingleton<_i6.DialogService>(
      () => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<_i6.NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<_i6.SnackbarService>(
      () => thirdPartyServicesModule.snackBarService);
  return getIt;
}

class _$ThirdPartyServicesModule extends _i7.ThirdPartyServicesModule {
  @override
  _i4.ApiClient get apiClient => _i4.ApiClient();

  @override
  _i5.ApiMethods get apiMethods => _i5.ApiMethods();

  @override
  _i6.BottomSheetService get bottomSheetService => _i6.BottomSheetService();

  @override
  _i6.DialogService get dialogService => _i6.DialogService();

  @override
  _i6.NavigationService get navigationService => _i6.NavigationService();

  @override
  _i6.SnackbarService get snackBarService => _i6.SnackbarService();
}
