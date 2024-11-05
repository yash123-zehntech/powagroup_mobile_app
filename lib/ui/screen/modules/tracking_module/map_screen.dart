// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapTrackingScreen extends StatefulWidget {
//   const MapTrackingScreen({super.key});

//   @override
//   State<MapTrackingScreen> createState() => MapTrackingScreenState();
// }

// class MapTrackingScreenState extends State<MapTrackingScreen> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   List<Marker> _markers = <Marker>[];

//   static const CameraPosition _kGooglePlex =
//       CameraPosition(target: LatLng(-33.865143, 151.209900), zoom: 20.0);

//   @override
//   void initState() {
//     _markers.add(Marker(
//         markerId: MarkerId('SomeId'),
//         position: LatLng(-33.865143, 151.209900),
//         infoWindow: InfoWindow(title: 'The title of the marker')));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         markers: Set<Marker>.of(_markers),
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/orderlist.model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/shipping_details_model.dart';
import 'package:powagroup/ui/screen/modules/splash_module/splash/splash_view_model.dart';
import 'package:powagroup/ui/screen/modules/tracking_module/tracking_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked/stacked.dart';

class MapTrackingScreen extends StatefulWidget {
  ShippingDetails? detailsShippingOrder;
  MapTrackingScreen({Key? key, this.detailsShippingOrder}) : super(key: key);
  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  // const SplashView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TrackingViewModel>.reactive(
      viewModelBuilder: () => TrackingViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.setUpLocation(widget.detailsShippingOrder);
        viewModel.getTime(widget.detailsShippingOrder);
      },
      builder: (context, viewModel, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
            title: 'Tracking Info',
            backIcon: IconButton(
              padding: EdgeInsets.only(left: 5.h),
              icon: Icon(
                PowaGroupIcon.back,
                size: 24.h,
                color: const Color(0xff36393C),
              ),
              onPressed: () {
                //viewModel.navigationService.back();
                Navigator.pop(context);
              },
            ),
          ),
        ),
        backgroundColor: const Color(0xffEFF1F2),
        body: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                "The order is on delivery now. The expected arrival time is ${viewModel.formattedDate} ${viewModel.formattedTime}.",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 6, 6, 6)),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              height: 400.h,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: Set<Marker>.of(viewModel.markers),
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.detailsShippingOrder!.latitude,
                        widget.detailsShippingOrder!.longitude),
                    zoom: 12.0),
                onMapCreated: (GoogleMapController controller) {
                  viewModel.controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
