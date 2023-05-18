import 'package:amber_bird/loader-page.dart';
import 'package:amber_bird/ui/pages/about-page.dart';
import 'package:amber_bird/ui/pages/account-page.dart';
import 'package:amber_bird/ui/pages/all-address-page.dart';
import 'package:amber_bird/ui/pages/help-center-page.dart';
import 'package:amber_bird/ui/pages/order-list.dart';
import 'package:amber_bird/ui/pages/product-guide-page.dart';
import 'package:amber_bird/ui/pages/tag-product-page.dart';
import 'package:amber_bird/ui/pages/wallet-page.dart';
import 'package:amber_bird/ui/pages/wishlist-page.dart';
import 'package:amber_bird/ui/widget/compilance-widget.dart';
import 'package:amber_bird/ui/widget/profile-widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:amber_bird/ui/pages/brand-product-page.dart';
import 'package:amber_bird/ui/pages/cart-page.dart';
import 'package:amber_bird/ui/pages/order-detail-page.dart';
import 'package:amber_bird/ui/pages/product-page.dart';
import 'package:amber_bird/ui/pages/referral-page.dart';

class WidgetRouteModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => LoaderPage(), children: [
      ChildRoute('/orders', child: (_, args) => OrderListPage()),
      ChildRoute('/refer-page', child: (_, args) => ReferralPage()),
      ChildRoute('/cart', child: (_, args) => CartPage()),
      // ChildRoute('/profile', child: (_, args) => ProfilePage()),
      ChildRoute('/account', child: (_, args) => AccountPage()),
      ChildRoute('/help-center', child: (_, args) => HelpCenterPage()),
      ChildRoute('/about-page', child: (_, args) => AboutPage()),
      ChildRoute('/edit-profile', child: (_, args) => EditProfilePage()),
      ChildRoute('/address-list', child: (_, args) => AllAddressPage()),
        ChildRoute(
        '/guide/:id',
        child: (_, args) {
          String productId = args.params['id'];
          return ProductGuidePage(productId);
        },
      ),
        ChildRoute(
        '/compilance/:id',
        child: (_, args) {
          String productId = args.params['id'];
          return CompilanceWidget(productId);
        },
      ),
      ChildRoute(
        '/brandProduct/:id',
        child: (_, args) {
          String productId = args.params['id'];
          return BrandProductPage(productId);
        },
      ),
      ChildRoute('/wishlist', child: (_, args) => WishListPage()),
      ChildRoute(
        '/order-detail',
        child: (_, args) {
          String orderId = args.data['id'];
          String navigateTo = args.data['navigateTo'] ?? '';
          return OrderDetailPage(orderId, navigateTo, search: false);
        },
      ),
      ChildRoute(
        '/product/:id',
        child: (_, args) {
          String productId = args.params['id'];
          return ProductPage(productId, search: false);
        },
      ),
       ChildRoute(
        '/tag-product/:id',
        child: (_, args) {
          String keyword = args.params['id'];
          if(keyword==''){
            keyword = args.fragment;
          }
          print(Uri.decodeComponent(keyword)) ;
          return TagProductPage(Uri.decodeComponent(keyword));
        },
      ),
      ChildRoute('/wallet', child: (_, args) => WalletPage()),
    ]),
  ];
}
