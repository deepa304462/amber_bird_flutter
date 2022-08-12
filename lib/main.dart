import 'package:amber_bird/app-module.dart';
import 'package:amber_bird/app-widget.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class ChangeLocale {
  static Function change = () {};
}

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final LocationController locationController = Get.put(LocationController());
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
