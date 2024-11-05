import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();
}

class SearchItemList {
  String? image;
  String? title;
  String? description;

  SearchItemList({this.image, this.title, this.description});
}
