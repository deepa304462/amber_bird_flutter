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
import 'package:lottie/lottie.dart';
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
      child: Stack(
        textDirection: TextDirection.ltr,
        alignment: AlignmentDirectional.topStart,
        children: [
          AppWidget(),
          Obx(
            () => controller.showLoader.value
                ? Expanded(
                    flex: 1,
                    child: Container(
                      height: 900,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Colors
                                  .transparent), //color is transparent so that it does not blend with the actual color specified

                          color: Color.fromARGB(126, 186, 179,
                              179) // Specifies the background color and the opacity
                          ),
                      // height: MediaQuery.of(context).size.width * 0.65,//200.0,
                      child: Lottie.network(
                          'https://assets6.lottiefiles.com/packages/lf20_34qRI0i4ti.json',
                          frameRate: FrameRate(50),
                          repeat: true),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    ),
  );
}
