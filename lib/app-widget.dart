import 'package:amber_bird/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    // warmupFlare();
    ChangeLocale.change = (Locale locale) {
      _currentLocale = locale;
      setState(() {});
    };
    super.initState();
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
