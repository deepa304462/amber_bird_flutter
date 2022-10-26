import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  Locale currentLocale = const Locale('en');
  Rx<LatLng> currentLatLang = LatLng(0, 0).obs;
  RxMap address = Map().obs;
  Rx<bool> mapLoad = false.obs;
  late GoogleMapController mapController;
  Dio dio = new Dio();
  LatLng latLng = LatLng(0, 0);
  Rx<Marker> currentPin = Marker(
    markerId: MarkerId('pin'),
  ).obs;
  String mapKey = 'AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo';
  @override
  void onInit() {
    getLocation();

    super.onInit();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<bool> getLocation() async {
    var locationExists =
        await OfflineDBService.checkBox(OfflineDBService.location);
    if (locationExists) {
      address.value = await OfflineDBService.get(OfflineDBService.location);
      if (address.value['geometry'] != null) {
        currentLatLang.value = LatLng(
            address.value['geometry']['location']['lat'],
            address.value['geometry']['location']['lng']);
      }

      currentPin.value =
          Marker(markerId: MarkerId('pin'), position: currentLatLang.value);
    }
    return locationExists;
  }

  locationReqest() {
    // initializeLocationAndSave();
  }

  Future<PermissionStatus> checkPermission() async {
    PermissionStatus serviceEnabled = await Location().hasPermission();
    return serviceEnabled;
  }

  void updatePosition(CameraPosition _position) {
    currentPin.value = Marker(
        markerId: MarkerId('pin'),
        position:
            LatLng(_position.target.latitude, _position.target.longitude));
    checkAddress(_position.target);
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    mapLoad.value = true;
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
    this.currentLatLang.value = currentLocation;
    currentPin.value =
        Marker(markerId: MarkerId('pin'), position: currentLocation);
    getAddressFromLatLng(locationData.latitude!, locationData.longitude!);
    mapLoad.value = false;
  }

  saveAddress() {
    OfflineDBService.save(OfflineDBService.location, address.value);
    Modular.to.navigate('home/main');
  }

  String findValueFromAddress(String key) {
    if (address.value['address_components'] != null) {
      for (dynamic element in (address.value['address_components'] as List)) {
        bool keyMatched = false;
        for (String value in (element['types'] as List)) {
          keyMatched = value == key;
          if (keyMatched) {
            break;
          }
        }
        if (keyMatched) {
          return element['long_name'];
        }
      }
    }

    return '';
  }

  getAddressFromLatLng(double lat, double lng) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$mapKey&language=en&latlng=$lat,$lng';
    if (lat != null && lng != null) {
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        address.value = response.data["results"][0];
      }
    }
  }

  void getNearbyWareHouseData(latitude, longitude, countryshortCode) async {
    var payload = {
      "userCoordinates": [latitude, longitude],
      "countryCode": countryshortCode,
    };
    var response = await ClientService.post(
        path: 'productInventory/getNearestWarehouse', payload: payload);
    if (response.statusCode == 200) {}
  }

  void checkAddress(LatLng coOrdinate) {
    getAddressFromLatLng(coOrdinate.latitude, coOrdinate.longitude);
  }
}
