// ignore: file_names
import 'dart:developer';

import 'package:amber_bird/ui/widget/internet-status.dart';
import 'package:amber_bird/utils/internet-connection-util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart' as flutter_modular;
import 'package:get/get.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      routerDelegate: flutter_modular.Modular.routerDelegate,
      routeInformationParser: flutter_modular.Modular.routeInformationParser,
      title: "App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.grey,
      ),
    );
  }
}
