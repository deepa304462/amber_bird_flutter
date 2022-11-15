import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/geo_address.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  Locale currentLocale = const Locale('en');
  Rx<LatLng> currentLatLang = const LatLng(0, 0).obs;
  RxMap address = {}.obs;
  Rx<Address> addressData = Address().obs;
  Rx<Address> changeAddressData = Address().obs;

  Rx<bool> mapLoad = false.obs;
  late GoogleMapController mapController;
  Dio dio = Dio();
  LatLng latLng = const LatLng(0, 0);
  Rx<Marker> currentPin = const Marker(
    markerId: MarkerId('pin'),
  ).obs;
  String mapKey = 'AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo';
  @override
  void onInit() {
    super.onInit();
    setLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setLocation() async {
    var locationExists =
        await OfflineDBService.checkBox(OfflineDBService.customerInsight);
    if (locationExists) {
      var insight =
          await OfflineDBService.get(OfflineDBService.customerInsight);
      print(insight);
      CustomerInsight cust = CustomerInsight.fromJson(jsonEncode(insight));
      if (cust.addresses!.isNotEmpty) {
        addressData.value = cust.addresses![cust.addresses!.length - 1];
      } else {
        getLocation();
      }
    } else {
      getLocation();
    }
  }

  Future<bool> getLocation() async {
    var locationExists =
        await OfflineDBService.checkBox(OfflineDBService.location);
    if (locationExists) {
      var data = await OfflineDBService.get(OfflineDBService.location);
      address.value = data;
      setAddressData(address.value);
      currentPin.value = Marker(
          markerId: const MarkerId('pin'), position: currentLatLang.value);
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
        markerId: const MarkerId('pin'),
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
    currentLatLang.value = currentLocation;
    currentPin.value =
        Marker(markerId: const MarkerId('pin'), position: currentLocation);
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
    String host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$host?key=$mapKey&language=en&latlng=$lat,$lng';
    if (lat != null && lng != null) {
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        addressData.value = response.data["results"][0];
        setAddressData(address.value);
      }
    }
  }

  setAddressData(dynamic data) {
    addressData.value.zipCode = findValueFromAddress('postal_code');
    addressData.value.name = '';
    addressData.value.line1 = data['formatted_address'];
    addressData.value.city = findValueFromAddress('locality') ??
        findValueFromAddress('administrative_area_level_2');
    addressData.value.country = findValueFromAddress('country');
    addressData.value.geoAddress = GeoAddress.fromMap({
      'coordinates': [
        data['geometry']['location']['lat'],
        data['geometry']['location']['lng']
      ]
    });
    if (data['geometry'] != null) {
      currentLatLang.value = LatLng(data['geometry']['location']['lat'],
          data['geometry']['location']['lng']);
    }

    // setAddressCall();
  }

  setAddressCall() async {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      if (controller.isLogin.value) {
        var insightDetail =
            await OfflineDBService.get(OfflineDBService.customerInsight);
        CustomerInsight cust =
            CustomerInsight.fromMap(insightDetail as Map<String, dynamic>);
        if (cust.addresses!.isEmpty) {
          cust.addresses = [addressData.value];
        } else {
          cust.addresses![cust.addresses!.length - 1] = (addressData.value);
        }

        var payload = cust.toMap();
        log(payload.toString());
        var userData = jsonDecode(await (SharedData.read('userData')));
        var response = await ClientService.Put(
            path: 'customerInsight',
            id: userData['mappedTo']['_id'],
            payload: payload);

        if (response.statusCode == 200) {
          OfflineDBService.save(
              OfflineDBService.customerInsight, response.data);
        }
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

  setFielsvalue(String text, String name) {
    if (text != null) {
      if (name == 'city') {
        changeAddressData.value.city = text;
      } else if (name == 'country') {
        changeAddressData.value.country = text;
      } else if (name == 'line1') {
        changeAddressData.value.line1 = text;
      } else if (name == 'line2') {
        changeAddressData.value.line2 = text;
      } else if (name == 'localArea') {
        changeAddressData.value.localArea = text;
      } else if (name == 'addressType') {
        changeAddressData.value.addressType = text;
      } else if (name == 'directionComment') {
        changeAddressData.value.directionComment = text;
      } else if (name == 'landMark') {
        changeAddressData.value.landMark = text;
      } else if (name == 'zipCode') {
        changeAddressData.value.zipCode = text;
      } else if (name == 'name') {
        changeAddressData.value.name = text;
      }
    }
  }
}
