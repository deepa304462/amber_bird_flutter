import 'package:amber_bird/home-page-module.dart';
import 'package:amber_bird/ui/pages/login-page.dart';
import 'package:amber_bird/ui/pages/product-guide-page.dart';
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
        // ChildRoute('/', child: (_, args) => LoginPageWidget()),
        ChildRoute('/splash', child: (_, args) => SplashOfferPage()),
        ChildRoute('/verify', child: (_, args) {
          return EmailVerificationPage(
              args.queryParams['email']!, args.queryParams['token']!);
        }),
        ChildRoute('/refer/:id', child: (_, args) {
          return WildCardRoutePage(args.uri);
        }),
        ModuleRoute('/', module: HomePageModule()),
        WildcardRoute(child: (context, args) {
          return WildCardRoutePage(args.uri);
        }),
        ChildRoute('/login', child: (_, args) => LoginPageWidget()),
        ChildRoute('/signup', child: (_, args) => SignUp()),
        ChildRoute(
          '/guide/:id',
          child: (_, args) {
            String productId = args.params['id'];
            return ProductGuidePage(productId);
          },
        ),
        ModuleRoute('/widget', module: WidgetRouteModule()),
        // ChildRoute('/orders', child: (_, args) => OrderListPage()),
        // ChildRoute('/refer-page', child: (_, args) => ReferralPage()),
        // ChildRoute('/cart', child: (_, args) => CartPage()),
        // ChildRoute('/profile', child: (_, args) => ProfilePage()),
        // ChildRoute(
        //   '/brandProduct/:id',
        //   child: (_, args) {
        //     String productId = args.params['id'];
        //     return BrandProductPage(productId);
        //   },
        // ),
        // ChildRoute('/wishlist', child: (_, args) => WishListPage()),
        // ChildRoute(
        //   '/order-detail',
        //   child: (_, args) {
        //     String orderId = args.data['id'];
        //     String navigateTo = args.data['navigateTo'] ?? '';
        //     return OrderDetailPage(orderId, navigateTo, search: false);
        //   },
        // ),
        // ChildRoute(
        //   '/product/:id',
        //   child: (_, args) {
        //     String productId = args.params['id'];
        //     return ProductPage(productId, search: false);
        //   },
        // ),
        // ChildRoute('/wallet', child: (_, args) => WalletPage()),
        ChildRoute('/password-reset',
            child: (_, args) => ResetPasswordWidget(
                args.queryParams['email']!, args.queryParams['token']!)),
        ChildRoute('/auth/passwordReset',
            child: (_, args) => ResetPasswordWidget(
                args.queryParams['email']!, args.queryParams['token']!)),
      ];
}
