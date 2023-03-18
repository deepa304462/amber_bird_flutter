import 'package:amber_bird/app-module.dart';
import 'package:amber_bird/app-widget.dart';
import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/firebase-analytics-log.dart';
import 'package:amber_bird/services/firebase-cloud-message-sync-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// https://cdn2.sbazar.app/0ad51820-35be-4a37-8a41-fb3915c1b2a0
//flutter build apk --split-per-abi
// sbazar_123 is the password for play store
class ChangeLocale {
  static Function change = () {};
}

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyA3SVqPLIzueu2lCoriDUXvNftlvMgGeBY",
  //         authDomain: "sbazar-ce4b2.firebaseapp.com",
  //         projectId: "sbazar-ce4b2",
  //         storageBucket: "sbazar-ce4b2.appspot.com",
  //         messagingSenderId: "779408576826",
  //         appId: "1:779408576826:web:31a8adf7819a8d6ebf0003",
  //         measurementId: "G-EPJ2VNR9HQ"));
  await Firebase.initializeApp();
  await FCMSyncService.init();
  await OfflineDBService.init();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  AnalyticsService.logEvent('initalization', {
    "message": 'initalized App',
  });
  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // await FCMSyncService.tokenSync(Ref());

  // ignore: unused_local_variable
  final OnBoardingController onBoardingController =
      Get.put(OnBoardingController());
  // ignore: unused_local_variable
  final LocationController locationController = Get.put(LocationController());
  final AuthController authController = Get.put(AuthController());
  final Controller controller = Get.put(Controller());
  runApp(
    ModularApp(
      module: AppModule(),
      child: AppWidget(),
    ),
  );
}
