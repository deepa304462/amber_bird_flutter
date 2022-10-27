import 'package:amber_bird/app-module.dart';
import 'package:amber_bird/app-widget.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/services/firebase-cloud-message-sync-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  await Firebase.initializeApp();
  await FCMSyncService.init();
  await OfflineDBService.init();
  await FCMSyncService.tokenSync('');
  final LocationController locationController = Get.put(LocationController());
  final OnBoardingController onBoardingController =
      Get.put(OnBoardingController());
  runApp(
    ModularApp(module: AppModule(), child: AppWidget()),
  );
}
