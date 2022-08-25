import 'dart:developer';

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
    Rx<LatLng> currentLatLang = LatLng(0, 0).obs;
  @override
  void onInit() {
    getLocation();
    getCurrentLatLngFromSharedPrefs();

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
    Map data = (await getParsedReverseGeocoding(currentLocation));
    print(data);
    String currentAddress = data['address'];
    // String countryshortCode = "IN";//data['country']['short_code'];
    //  getNearbyWareHouseData(locationData.latitude!, locationData.longitude!, countryshortCode);
    SharedData.saveDouble(locationData.latitude!, 'latitude');
    SharedData.saveDouble(locationData.longitude!, 'longitude');
    SharedData.save(currentAddress, 'current-address');
    getCurrentLatLngFromSharedPrefs();
    address.value = (currentAddress);
  }

  getCurrentLatLngFromSharedPrefs() async {
    currentLatLang.value=  LatLng((await SharedData.readDouble('latitude')!),
        await SharedData.readDouble('longitude')!);
  }

 
  Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
    var response = await getReverseGeocodingGivenLatLngUsingMapbox(latLng);
    Map feature = response['features'][0];
    var countryObj = feature['context'].where((item) {
      print(item);
      // print(item['id'] ?? ''.contains('country'));
      if (item != null) {
        if (item['id'].contains('country')) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    });
    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': latLng,
      'country': countryObj
    };
    inspect(response);
    return revGeocode;
  }

  void getNearbyWareHouseData(latitude, longitude, countryshortCode) async {
    var payload = {
      "userCoordinates": [latitude, longitude],
      "countryCode": countryshortCode,
      // "productId": "string",
      // "varientCode": "string",
      // "productQuantity": 0
    };
    print(payload);
    var response = await ClientService.post(
        path: 'productInventory/getNearestWarehouse', payload: payload);
    if (response.statusCode == 200) {
      print(response.data);
    }
  }
}
