import 'dart:convert';

import 'package:amber_bird/main.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  Locale _currentLocale = Locale('en');
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
    var response =json.decode(await getReverseGeocodingGivenLatLngUsingMapbox(latLng));
    Map feature = response['features'][0];
    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': latLng
    };
    return revGeocode;
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // Get the current user location
    LocationData _locationData = await _location.getLocation();
    LatLng currentLocation =
        LatLng(_locationData.latitude!, _locationData.longitude!);
    print(currentLocation);
    // Get the current user address
    String currentAddress =(await getParsedReverseGeocoding(currentLocation))['place'];

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
