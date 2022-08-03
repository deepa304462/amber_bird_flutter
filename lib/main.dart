import 'package:amber_bird/app-module.dart';
import 'package:amber_bird/app-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class ChangeLocale {
  static Function change = () {};
}

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
