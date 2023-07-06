import 'package:amber_bird/home-page-module.dart';
import 'package:amber_bird/ui/pages/login-page.dart';
import 'package:amber_bird/ui/pages/reset-password-page.dart';
import 'package:amber_bird/ui/pages/sign-up.dart';
import 'package:amber_bird/ui/pages/wild-card-route-page.dart';
import 'package:amber_bird/ui/pages/email-verification-page.dart';
import 'package:amber_bird/ui/pages/splash-offer-page.dart';
import 'package:amber_bird/widget-module.dart';
import 'package:flutter_modular/flutter_modular.dart';

//http://localhost:64123/#/form/60e6b312c7f5dc000df40a1c/en
class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  List<Bind> get binds => [];

  // Provide all the routes for your module
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/splash', child: (_, args) => SplashOfferPage()),
        ChildRoute('/verify', child: (_, args) {
          return EmailVerificationPage(
              args.queryParams['email']!, args.queryParams['token']!);
        }),
        ChildRoute('/refer-app/:id', child: (_, args) {
          return WildCardRoutePage(args.uri);
        }),
        ModuleRoute('/',
            module: HomePageModule(), guards: [DynamicLinkGaurd()]),
        WildcardRoute(child: (context, args) {
          return WildCardRoutePage(args.uri);
        }),
        ChildRoute('/login', child: (_, args) => LoginPageWidget()),
        ChildRoute('/signup', child: (_, args) => SignUp()),
        ModuleRoute('/widget', module: WidgetRouteModule()),
        ChildRoute('/password-reset',
            child: (_, args) => ResetPasswordWidget(
                args.queryParams['email']!, args.queryParams['token']!)),
        ChildRoute('/auth/passwordReset',
            child: (_, args) => ResetPasswordWidget(
                args.queryParams['email']!, args.queryParams['token']!)),
      ];
}

class DynamicLinkGaurd extends RouteGuard {
  DynamicLinkGaurd() : super(redirectTo: '/wild-card');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    print(path);
    return true;
  }
}
