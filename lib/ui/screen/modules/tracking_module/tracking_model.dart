import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/shipping_details_model.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TrackingViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  List<Marker> markers = <Marker>[];

  CameraPosition kGooglePlex =
      CameraPosition(target: LatLng(-33.865143, 151.209900), zoom: 20.0);
  String _formattedDate = "";
  String get formattedDate => _formattedDate;

  set formattedDate(String formattedDate) {
    _formattedDate = formattedDate;
    notifyListeners();
  }

  String _formattedTime = "";
  String get formattedTime => _formattedTime;

  set formattedTime(String formattedDate) {
    _formattedTime = formattedDate;
    notifyListeners();
  }

  void setUpLocation(ShippingDetails? detailsShippingOrder) {
    markers.add(Marker(
        markerId: MarkerId('SomeId'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(
            detailsShippingOrder!.latitude, detailsShippingOrder.longitude),
        infoWindow: InfoWindow(title: 'The title of the marker')));

    notifyListeners();
  }

  void getTime(ShippingDetails? detailsShippingOrder) {
    String dateTimeString = detailsShippingOrder!.arrivalTimePlanned.toString();
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the date/month/year
    formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    // Format the time
    formattedTime = DateFormat('HH:mm').format(dateTime);
  }
}
