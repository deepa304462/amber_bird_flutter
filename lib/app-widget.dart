import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart' as flutter_modular;
import 'package:get/get.dart';

class AppWidget extends StatelessWidget {
  // const AppWidget({super.key});

  // Locale _currentLocale = const Locale('en');
  // @override
  // void initState() {
  //   // FlutterNativeSplash.remove();
  //   // warmupFlare();
  //   // initializeLocationAndSave();
  //   // ChangeLocale.change = (Locale locale) {
  //   //   _currentLocale = locale;
  //   //   // setState(() {});
  //   // };
  //   // super.initState();
  // }

  // Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
  //   var response = await getReverseGeocodingGivenLatLngUsingMapbox(latLng);
  //   // print(resp);
  //   // var response =resp;
  //   Map feature = response['features'][0];
  //   Map revGeocode = {
  //     'name': feature['text'],
  //     'address': feature['place_name'].split('${feature['text']}, ')[1],
  //     'place': feature['place_name'],
  //     'location': latLng
  //   };
  //   print(revGeocode);
  //   return revGeocode;
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      routerDelegate: flutter_modular.Modular.routerDelegate,
      routeInformationParser: flutter_modular.Modular.routeInformationParser,
      title: "App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Barlow',
        primarySwatch: Colors.grey,
      ),
    );
  }
}
