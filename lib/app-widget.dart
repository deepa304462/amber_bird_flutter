import 'dart:convert';

import 'package:amber_bird/main.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class AppWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppWidget();
  }
}

class _AppWidget extends State<AppWidget> {
  Locale _currentLocale = const Locale('en');
  @override
  void initState() {
    FlutterNativeSplash.remove();
    // warmupFlare();
    initializeLocationAndSave();
    ChangeLocale.change = (Locale locale) {
      _currentLocale = locale;
      setState(() {});
    };
    super.initState();
  }

  Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
    var response  = await getReverseGeocodingGivenLatLngUsingMapbox(latLng);
    // print(resp);
    // var response =resp; 
    Map feature = response['features'][0];
    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': latLng
    };
    print(revGeocode);
    return revGeocode;
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
    String currentAddress =(await getParsedReverseGeocoding(currentLocation))['place'];
     print('addd${currentAddress}');
    // Store the user location in sharedPreferences
    // sharedPreferences.setDouble('latitude', _locationData.latitude!);
    // sharedPreferences.setDouble('longitude', _locationData.longitude!);
    // sharedPreferences.setString('current-address', currentAddress);

    // Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (_) => const Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _currentLocale,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
      title: "App",
      theme: ThemeData(
        fontFamily: 'Barlow',
        primarySwatch: Colors.grey,
      ),
    );
  }
}
