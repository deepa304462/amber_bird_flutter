import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationController extends GetxController {
  var address = ''.obs;
  Locale currentLocale = const Locale('en');
  @override
  void onInit() {
    getLocation();

    super.onInit();
  }

  void getLocation() async {
    String ad = (await SharedData.read('current-address')).toString();
    if (ad != '{}') {
      address.value = (ad);
    }
  }

  locationReqest() {
    initializeLocationAndSave();
  }

  Future<PermissionStatus> checkPermission() async {
    PermissionStatus serviceEnabled = await Location().hasPermission();
    return serviceEnabled;
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get the current user location
    LocationData locationData = await location.getLocation();
    LatLng currentLocation =
        LatLng(locationData.latitude!, locationData.longitude!);
    print(currentLocation);
    // Get the current user address
    String currentAddress =
        (await getParsedReverseGeocoding(currentLocation))['address'];
    SharedData.save(locationData.latitude!.toString(), 'latitude');
    SharedData.save(locationData.longitude!.toString(), 'longitude');
    SharedData.save(currentAddress, 'current-address');
    address.value = (currentAddress);
  }

  Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
    var response = await getReverseGeocodingGivenLatLngUsingMapbox(latLng);
    Map feature = response['features'][0];
    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': latLng
    };
    return revGeocode;
  }
}
