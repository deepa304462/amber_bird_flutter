import 'package:amber_bird/controller/location-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class SearchLocationFromMapPage extends StatelessWidget {
  LocationController locationController = Get.find();

  // Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;
  @override
  Widget build(BuildContext context) {
    LatLng currentLocation = locationController.currentLatLang.value;
    late String currentAddress = locationController.address.value;
    late CameraPosition _initialCameraPosition =
        CameraPosition(target: currentLocation, zoom: 14);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              initialCameraPosition: _initialCameraPosition,
              // onMapCreated: _onMapCreated,
              // onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // controller.animateCamera(
          //     CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
