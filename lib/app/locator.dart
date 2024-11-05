import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:powagroup/app/locator.config.dart';

final locator = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void configureDependencies() => $initGetIt(locator);
