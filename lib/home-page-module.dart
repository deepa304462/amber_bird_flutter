import 'package:amber_bird/ui/pages/cart-page.dart';
import 'package:amber_bird/ui/pages/category-page.dart';
import 'package:amber_bird/ui/pages/home-page.dart';
import 'package:amber_bird/ui/pages/location-page.dart';
import 'package:amber_bird/ui/pages/login-page.dart';
import 'package:amber_bird/ui/pages/main-page.dart';
import 'package:amber_bird/ui/pages/product-page.dart';
import 'package:amber_bird/ui/pages/profile-page.dart';
import 'package:amber_bird/ui/pages/search-page.dart';
import 'package:amber_bird/ui/pages/sign-up.dart';
import 'package:amber_bird/ui/pages/splash-offer-page.dart';
import 'package:amber_bird/ui/widget/searct-location.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomePageModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/',
        child: (_, args) => SplashOfferPage(), guards: [AppOnboardingGuard()]),
    ChildRoute('/location', child: (_, args) => LocationPage()),
    ChildRoute('/search-location',
        child: (_, args) => SearchLocationFromMapPage()),
    ChildRoute('/home', child: (_, args) => HomePage(), children: [
      ChildRoute('/main', child: (_, args) => MainPage()),
      ChildRoute(
        '/product/:id',
        child: (_, args) {
          String productId = args.params['id'];
          print(productId);
          return ProductPage(productId, search: false);
        },
      ),
      ChildRoute('/category', child: (_, args) => CategoryPage()),
      ChildRoute('/login', child: (_, args) => LoginPageWidget()),
      ChildRoute('/profile', child: (_, args) => ProfilePage()),
      ChildRoute('/cart', child: (_, args) => CartPage()),
      ChildRoute('/search', child: (_, args) => SearchPage()),
      ChildRoute('/signup', child: (_, args) => SignUp()),
    ]),
  ];
}

class AppOnboardingGuard extends RouteGuard {
  AppOnboardingGuard() : super(redirectTo: '/home/main');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    var onboardLocal = await (SharedData.read('onboardingDone'));
    bool onboard = onboardLocal.toString() != 'true';
    // bool onboard = false;
    FlutterNativeSplash.remove();
    return onboard;
  }
}
