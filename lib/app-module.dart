import 'package:amber_bird/home-page-module.dart';
import 'package:amber_bird/ui/pages/reset-password-page.dart';
import 'package:amber_bird/ui/pages/wild-card-route-page.dart';
import 'package:amber_bird/ui/pages/email-verification-page.dart';
import 'package:amber_bird/ui/pages/splash-offer-page.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';

//http://localhost:64123/#/form/60e6b312c7f5dc000df40a1c/en
class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  List<Bind> get binds => [];

  // Provide all the routes for your module
  @override
  List<ModularRoute> get routes => [
        // ChildRoute('/', child: (_, args) => LoginPageWidget()),
        ChildRoute('/splash', child: (_, args) => SplashOfferPage()),
        ChildRoute('/verify', child: (_, args) {
          return EmailVerificationPage(
              args.queryParams['email']!, args.queryParams['token']!);
        }),
        ChildRoute('/refer/:id', child: (_, args) { 
          SharedData.save(args.params['id'].toString(), 'referredbyId');
          return WildCardRoutePage(args.uri);
        }),
        ModuleRoute('/', module: HomePageModule()),
        WildcardRoute(child: (context, args) {
          return WildCardRoutePage(args.uri);
        }),
        ChildRoute('/password-reset',
            child: (_, args) => ResetPasswordWidget(
                args.queryParams['email']!, args.queryParams['token']!)),
        ChildRoute('/auth/passwordReset',
            child: (_, args) => ResetPasswordWidget(
                args.queryParams['email']!, args.queryParams['token']!)),
      ];
}
