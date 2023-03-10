import 'dart:async';
import 'dart:developer';

import 'package:amber_bird/data/appmanger/appmanger.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/app-update.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../ui/widget/internet-status.dart';
import '../utils/internet-connection-util.dart';

class OnBoardingController extends GetxController {
  var onboardingData = Appmanger().obs;
  var activePage = 0.obs;
  bool internetConnectivityListenerAdded = false;
  bool firebaseRemoteConfigListenerAdded = false;
  bool isShowUpdateCard = false;
  @override
  void onInit() {
    getOboarding();

    super.onInit();
  }

  firebaseRemoteConfigListenerAdd(BuildContext context) async {
    if (!firebaseRemoteConfigListenerAdded) {
      final remoteConfig = FirebaseRemoteConfig.instance;

      remoteConfig
          .setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(seconds: 60),
      ))
          .then((value) {
        if (!kDebugMode || true) {
          Timer.periodic(const Duration(seconds: 60), (Timer t) {
            remoteConfig.fetchAndActivate().then((value) async {
              print(remoteConfig.getValue('app_android_version').asInt());
              PackageInfo packageInfo = await PackageInfo.fromPlatform();

              int androidAppVersionOnRemote =
                  remoteConfig.getValue('app_android_version').asInt();
              if (int.parse(packageInfo.buildNumber) <
                  androidAppVersionOnRemote) {
                if (!isShowUpdateCard) {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    useRootNavigator: true,
                    elevation: 15,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AppUpdate(),
                      );
                    },
                  );
                }
                isShowUpdateCard = true;
              } else {
                if (isShowUpdateCard) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isShowUpdateCard = false;
                }
              }
            });
          });
        }
      });
    }
    firebaseRemoteConfigListenerAdded = true;
  }

  addInternetConnectivity(BuildContext context) {
    if (!internetConnectivityListenerAdded) {
      InternetConnectionUtil.listenConnection(context).onData((data) {
        if (data == ConnectivityResult.none) {
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            useRootNavigator: true,
            elevation: 15,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const InternetStatus(),
              );
            },
          );
        }
      });
    }
    internetConnectivityListenerAdded = true;
  }

  getOboarding() async {
    var response = await ClientService.get(
        path: 'appManager', id: '60180d73-0c10-4d04-a22a-00ab2137e31f');

    if (response.statusCode == 200) {
      Appmanger data = Appmanger.fromMap(response.data as Map<String, dynamic>);
      onboardingData.value = (data);
      OfflineDBService.save(OfflineDBService.appManager, data.toJson());
    }
  }
}
