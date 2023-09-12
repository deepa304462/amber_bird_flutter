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
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/location/location.dart';
import 'dart:async';

class LocationController extends GetxController {
  // Locale currentLocale = const Locale('en');
  Rx<LatLng> currentLatLang = const LatLng(26.4770531, 80.2878786).obs;
  RxMap<dynamic, dynamic> address = <dynamic, dynamic>{}.obs;
  RxInt seelctedIndexToEdit = 0.obs;
  Rx<Address> addressData = Address().obs;
  Rx<Address> deliveryAddress = Address().obs;
  Rx<Address> changeAddressData = Address().obs;
  Rx<Location> location = Location().obs;
  Rx<String> pinCode = ''.obs;
  RxInt addAddressApiCallCount = 0.obs;
  RxList pincodeSuggestions = [].obs;
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  Rx<bool> mapLoad = false.obs;
  Rx<bool> addressAvaiable = false.obs;
  // late GoogleMapController mapController;
  RxString addressErrorString = ''.obs;
  Dio dio = Dio();
  RxBool error = false.obs;
  // LatLng latLng = const LatLng(0, 0);
  // Rx<GoogleMapController> mapController;
  Rx<Marker> currentPin = const Marker(
    markerId: MarkerId('pin'),
  ).obs;
  String mapKey = 'AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo';

  Rx<GoogleMapController>? gmapController;

  @override
  void onInit() {
    currentLatLang.value = LatLng(52.520008, 13.404954);
    setLocation();
    super.onInit();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLang.value, zoom: 18)));
  }

  Future<void> searchPincode(String changedText) async {
    if (changedText.length > 2) {
      var url =
          'https://api.geoapify.com/v1/geocode/autocomplete?text=${changedText}&limit=10&lang=de&apiKey=1f1c1cf8a8b6497bb721b99d76567726&filter=countrycode:de';
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        pincodeSuggestions.value =
            (response.data['features'] as List).map((e) => e).toList();
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
        if (pinCode.value.isEmpty) {
          var pin = await SharedData.read('pinCode');
          pinCode.value = pin ?? '0';
        }
      }
    } else {
      var pin = await SharedData.read('pinCode');
      pinCode.value = pin ?? '0';
      // getLocation();
    }
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

  String findValueFromAddress(String key) {
    if (address['address_components'] != null) {
      for (dynamic element in (address['address_components'] as List)) {
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
          return {"msg": "Oops, Something went Wrong!!", "status": "error"};
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
        addAddressApiCallCount.value = addAddressApiCallCount.value + 1;
        cust.addresses!.add(addressData.value);

        var payload = cust.toMap();
        var userData =
            jsonDecode((await (SharedData.read('userData'))) ?? '{}');
        var response = await ClientService.Put(
            path: 'customerInsight',
            id: userData['mappedTo']['_id'],
            payload: payload);
        if (response.statusCode == 200) {
          OfflineDBService.save(
              OfflineDBService.customerInsight, response.data);
          setLocation();
          return {"msg": "Updated Successfully!!", "status": "success"};
        } else if (response.statusCode == 500) {
          if (addAddressApiCallCount.value < 2) {
            await controller
                .getCustomerDetail(controller.loggedInProfile.value.id);
            addAddressCall();
          } else {
            return {"msg": "Oops, Something went Wrong!!", "status": "error"};
          }
        } else {
          return {"msg": "Oops, Something went Wrong!!", "status": "error"};
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
        addressFromGoogle['properties']['postcode'];
    // findValueFromAddressFromGoogleData(addressFromGoogle, 'postal_code');
    changeAddressData.value.houseNo =
        addressFromGoogle['properties']['housenumber'];
    changeAddressData.value.line1 =
        '${addressFromGoogle['properties']['street']} ';
    changeAddressData.value.city = addressFromGoogle['properties']['city'] != ''
        ? addressFromGoogle['properties']['city']
        : addressFromGoogle['properties']['district'];
    changeAddressData.value.country =
        addressFromGoogle['properties']['country'];
    changeAddressData.refresh();
    changeAddressData.value.geoAddress = GeoAddress.fromMap({
      'coordinates': [
        addressFromGoogle['properties']['lat'],
        addressFromGoogle['properties']['lon']
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

  Future<String> getCoordinate() {
    // isLoading.value = true;
    return ClientService.get(path: 'shipping/getGenericAddressWithIp')
        .then((value) {
      print("fhtfhfh" + value.data.toString());
      var locations = Location.fromJson(value.data);
      location.value = locations;

      // currentLatLang.value=LatLng(26.4770531, 80.2878786) ;
      // currentPin.value = Marker(
      //     markerId: const MarkerId('pin'),
      //     position:
      //     LatLng(26.4770531, 80.2878786)
      // );

      currentLatLang.value = LatLng(locations.geo!.coordinates![1].toDouble(),
          locations.geo!.coordinates![0].toDouble());
      gmapController?.value.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLang.value, zoom: 12)));
      // updatePosition(CameraPosition(target: currentLatLang.value, zoom: 12));

      print("latitude" + locations.geo!.coordinates![0].toString());
      print("longitude" + locations.geo!.coordinates![1].toString());
      return '';
    });
  }
}
