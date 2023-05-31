import 'dart:convert';

import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/geo_address.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/data/user_profile/user_profile.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//https://maps.googleapis.com/maps/api/geocode/json?address=84%20Ghanta%20Mandir&sensor=true&components=postal_code:243001|country:IN&key=AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo
//https://maps.googleapis.com/maps/api/geocode/json?address=226010&sensor=true&key=AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo

//https://stackoverflow.com/questions/73612276/flutter-google-maps-how-to-show-active-areas-with-border
class LocationController extends GetxController {
  // Locale currentLocale = const Locale('en');
  Rx<LatLng> currentLatLang = const LatLng(0, 0).obs;
  RxMap address = {}.obs;
  RxInt seelctedIndexToEdit = 0.obs;
  Rx<Address> addressData = Address().obs;
  Rx<Address> deliveryAddress = Address().obs;
  Rx<Address> changeAddressData = Address().obs;
  Rx<String> pinCode = ''.obs;

  Rx<bool> mapLoad = false.obs;
  Rx<bool> addressAvaiable = false.obs;
  late GoogleMapController mapController;
  RxString addressErrorString = ''.obs;
  Dio dio = Dio();
  RxBool error = false.obs;
  LatLng latLng = const LatLng(0, 0);
  Rx<Marker> currentPin = const Marker(
    markerId: MarkerId('pin'),
  ).obs;
  String mapKey = 'AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo';
  @override
  void onInit() {
    currentLatLang.value = LatLng(52.520008, 13.404954);
    setLocation();
    super.onInit();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> findLocalityFromPinCode() async {
    String host = 'https://maps.google.com/maps/api/geocode/json';
    final url =
        '$host?address=zip ${pinCode.value}&sensor=true&key=$mapKey&language=de&components=country:de';
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      if (response.data['results'].length > 0) {
        dynamic southwest =
            response.data['results'][0]['geometry']['bounds']['southwest'];
        dynamic northeast =
            response.data['results'][0]['geometry']['bounds']['northeast'];
        mapController.obs.value.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(southwest['lat'], southwest['lng']),
                northeast: LatLng(northeast['lat'], northeast['lng'])),
            1));
        dynamic centerLocation =
            response.data['results'][0]['geometry']['location'];
        checkAddress(LatLng(centerLocation['lat'], centerLocation['lng']));
      }
    }
  }

  void setLocation() async {
    var locationExists =
        await OfflineDBService.checkBox(OfflineDBService.customerInsight);
    if (locationExists) {
      var insight =
          await OfflineDBService.get(OfflineDBService.customerInsight);
      CustomerInsight cust = CustomerInsight.fromJson(jsonEncode(insight));
      if (cust.addresses!.isNotEmpty) {
        addressData.value = cust.addresses![cust.addresses!.length - 1];
        pinCode.value = addressData.value.zipCode ?? '0';
      } else {
        addressData.value = Address();
        pinCode.value = '0';
        // getLocation();
      }
    } else {
      // getLocation();
    }
  }

  getLocation() async {
    // var locationExists =
    //     await OfflineDBService.checkBox(OfflineDBService.location);
    // if (locationExists) {
    //   var data = await OfflineDBService.get(OfflineDBService.location);
    //   address.value = data;
    setAddressData(address.value);
    pinCode.value = addressData.value.zipCode!;
    if (pinCode.value.isNotEmpty) {
      addressAvaiable.value = true;
    }
    // }
    // return locationExists;
  }

  locationReqest() {
    // initializeLocationAndSave();
  }

  void updatePosition(CameraPosition _position) {
    currentPin.value = Marker(
        markerId: const MarkerId('pin'),
        position:
            LatLng(_position.target.latitude, _position.target.longitude));
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    mapLoad.value = true;
    mapLoad.value = false;
  }

  saveAddress() {
    // OfflineDBService.save(OfflineDBService.location, address.value);
    pinCode.value = findValueFromAddress('postal_code');

    // getLocation();
    try {
      if (Modular.to.canPop())
        Modular.to.pop(this.address);
      else
        Modular.to.pushReplacementNamed('/home/main');
    } catch (e) {
      Modular.to.pushReplacementNamed('/home/main');
      // code that handles the exception
    }
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

  String findValueFromAddressFromGoogleData(
      Map<String, dynamic> googleData, String key) {
    if (googleData['address_components'] != null) {
      for (dynamic element in (googleData['address_components'] as List)) {
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
    final url = '$host?key=$mapKey&language=de&latlng=$lat,$lng';
    if (lat != null && lng != null) {
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        address.value = response.data["results"][0];
        var zipcode = findValueFromAddress('postal_code');
        if (pinCode.value != zipcode) {
          error.value = true;
          address.value = Map();
        } else {
          error.value = false;
          if (address.value['geometry'] != null) {
            currentLatLang.value = LatLng(
                address.value['geometry']['location']['lat'],
                address.value['geometry']['location']['lng']);
            addressAvaiable.value = true;
          }
        }

        // setAddressData(address.value);
      }
    }
  }

  setAddressData(dynamic data) {
    addressAvaiable.value = true;
    addressData.value.zipCode = findValueFromAddress('postal_code');
    addressData.value.line1 = data['formatted_address'];
    addressData.value.localArea = findValueFromAddress('sublocality_level_1');
    addressData.value.city = findValueFromAddress('locality') ??
        findValueFromAddress('administrative_area_level_2');
    addressData.value.country = findValueFromAddress('country');
    addressData.value.geoAddress = GeoAddress.fromMap({
      'coordinates': [
        data['geometry']['location']['lat'],
        data['geometry']['location']['lng']
      ]
    });
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
          pinCode.value = addressData.value.zipCode!;
        } else {
          cust.addresses![cust.addresses!.length - 1] = (addressData.value);
        }
        var payload = cust.toMap();
        // log(payload.toString());
        var userData =
            jsonDecode((await (SharedData.read('userData')) ?? '{}'));
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

  editAddressCall() async {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      if (controller.isLogin.value) {
        var insightDetail =
            await OfflineDBService.get(OfflineDBService.customerInsight);
        CustomerInsight cust =
            CustomerInsight.fromMap(insightDetail as Map<String, dynamic>);
        cust.addresses![seelctedIndexToEdit.value] = (addressData.value);
        var payload = cust.toMap();
        // log(payload.toString());
        var userData = jsonDecode(await (SharedData.read('userData')) ?? '{}');
        var response = await ClientService.Put(
            path: 'customerInsight',
            id: userData['mappedTo']['_id'],
            payload: payload);
        if (response.statusCode == 200) {
          OfflineDBService.save(
              OfflineDBService.customerInsight, response.data);
          setLocation();
          return {"msg": "Updated Successfully!!", "status": "success"};
        } else {
          return {"msg": "Something Went Wrong!!", "status": "error"};
        }
      }
    }
  }

  addAddressCall() async {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      if (controller.isLogin.value) {
        var insightDetail =
            await OfflineDBService.get(OfflineDBService.customerInsight);
        CustomerInsight cust =
            CustomerInsight.fromMap(insightDetail as Map<String, dynamic>);

        cust.addresses!.add(addressData.value);

        var payload = cust.toMap();
        // log(payload.toString());
        var userData =
            jsonDecode((await (SharedData.read('userData'))) ?? '{}');
        var response = await ClientService.Put(
            path: 'customerInsight',
            id: userData['mappedTo']['_id'],
            payload: payload);
        if (response.statusCode == 200) {
          // getLocation();
          OfflineDBService.save(
              OfflineDBService.customerInsight, response.data);
          setLocation();
          return {"msg": "Updated Successfully!!", "status": "success"};
        } else {
          return {"msg": "Something Went Wrong!!", "status": "error"};
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
    if (name == 'city') {
      changeAddressData.value.city = text;
    } else if (name == 'houseNo') {
      changeAddressData.value.houseNo = text;
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
    } else if (name == 'phoneNumber') {
      changeAddressData.value.phoneNumber = text;
    }

    changeAddressData.refresh();
  }

  void updateCustomerAddress(addressFromGoogle) {
    changeAddressData.value.zipCode =
        findValueFromAddressFromGoogleData(addressFromGoogle, 'postal_code');
    changeAddressData.value.name = '';
    changeAddressData.value.houseNo =
        findValueFromAddressFromGoogleData(addressFromGoogle, 'premise');
    changeAddressData.value.line1 = findValueFromAddressFromGoogleData(
            addressFromGoogle, 'sublocality_level_2') +
        ', ' +
        findValueFromAddressFromGoogleData(
            addressFromGoogle, 'sublocality_level_1');
    changeAddressData.value.city =
        findValueFromAddressFromGoogleData(addressFromGoogle, 'locality') ??
            findValueFromAddressFromGoogleData(
                addressFromGoogle, 'administrative_area_level_2');
    changeAddressData.value.country =
        findValueFromAddressFromGoogleData(addressFromGoogle, 'country');
    changeAddressData.refresh();
    changeAddressData.value.geoAddress = GeoAddress.fromMap({
      'coordinates': [
        addressFromGoogle['geometry']['location']['lat'],
        addressFromGoogle['geometry']['location']['lng']
      ]
    });
  }

  Future<void> setInitialDataForNewAddress() async {
    try {
      var loggedInProfile = UserProfile.fromMap(
          await OfflineDBService.get(OfflineDBService.userProfile));
      changeAddressData.value.name = loggedInProfile.fullName;
      changeAddressData.value.phoneNumber = loggedInProfile.mobile;
      if (changeAddressData.value.zipCode == null ||
          changeAddressData.value.zipCode!.isEmpty) {
        changeAddressData.value.zipCode = pinCode.value;
      }
      changeAddressData.refresh();
    } catch (e) {}
  }
}
