import 'package:amber_bird/app-module.dart';
import 'package:amber_bird/app-widget.dart';
import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/services/firebase-analytics-log.dart';
import 'package:amber_bird/services/firebase-cloud-message-sync-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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

// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
void main() async {
  await dotenv.load(fileName: "assets/config/.env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  await FCMSyncService.init();
  await OfflineDBService.init();
  AnalyticsService.logEvent('initalization', {
    "message": 'initalized App',
  });

  // Check if you received the link via `getInitialLink` first
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {
    final Uri deepLink = initialLink.link;
    Modular.to.navigate(deepLink.path);
    // Example of using the dynamic link to push the user to a different screen
  }

  FirebaseDynamicLinks.instance.onLink.listen(
    (pendingDynamicLinkData) {
      // Set up the `onLink` event listener next as it may be received here
      final Uri deepLink = pendingDynamicLinkData.link;
      Modular.to.navigate(deepLink.path);
    },
  );

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
  Get.put(AuthController());
  Get.put(WishlistController());
  Get.put(Controller());

  Get.put(AppbarScrollController());
  runApp(
    ModularApp(module: AppModule(), child: AppWidget()),
  );
}
