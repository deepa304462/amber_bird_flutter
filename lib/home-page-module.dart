import 'dart:convert';

import 'package:amber_bird/ui/pages/category-page.dart';
import 'package:amber_bird/ui/pages/coin-wallet-page.dart';
import 'package:amber_bird/ui/pages/home-page.dart';
import 'package:amber_bird/ui/pages/location-page.dart';
import 'package:amber_bird/ui/pages/main-page.dart';
import 'package:amber_bird/ui/pages/payment-status-page.dart';
import 'package:amber_bird/ui/pages/splash-offer-page.dart';
import 'package:amber_bird/ui/widget/add-address.dart';
import 'package:amber_bird/ui/widget/inAppView.dart';
import 'package:amber_bird/ui/widget/scoin-checkout-widget.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:showcaseview/showcaseview.dart';

import 'ui/pages/brand-page.dart';

class HomePageModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/',
        child: (_, args) => SplashOfferPage(), guards: [AppOnboardingGuard()]),
    ChildRoute('/location', child: (_, args) => LocationPage()),
    ChildRoute('/home',
        child: (_, args) =>
            ShowCaseWidget(builder: Builder(builder: (context) => HomePage())),
        children: [
          ChildRoute('/add-address', child: (_, args) => AddAddress()),
          ChildRoute('/main', child: (_, args) => MainPage()),
          ChildRoute(
            '/paymentStatus/:id/:paymentId',
            child: (_, args) {
              String id = args.params['id'];
              String paymentId = args.params['paymentId'];
              return PaymentSatusPage(id, paymentId);
            },
          ),
          ChildRoute('/scoin-checkout',
              child: (_, args) => ScoinCheckoutWidget()),
          ChildRoute('/category', child: (_, args) => CategoryPage()),
          ChildRoute('/coin-wallet', child: (_, args) => CoinWalletPage()),
          ChildRoute('/inapp', child: (_, args) => InApp()),
          ChildRoute('/brand', child: (_, args) => BrandPage()),
        ]),
  ];
}

class AppOnboardingGuard extends RouteGuard {
  AppOnboardingGuard() : super(redirectTo: '/home/main');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    var onboardLocal =
        jsonDecode(await (SharedData.read('onboardingDone')) ?? '{}');
    bool onboard = true;
    if (onboardLocal['time'] != null) {
      String expire = onboardLocal['time'] ?? '';
      var newDate = DateTime.now().toUtc();
      var difference = DateTime.parse(expire).difference(newDate);
      if ((difference.inDays).abs() >= 3) {
        SharedData.remove('onboardingDone');
      } else {
        onboard = false;
      }
    }
    FlutterNativeSplash.remove();
    return onboard;
  }
}
