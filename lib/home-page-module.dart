import 'package:amber_bird/ui/pages/cart-page.dart';
import 'package:amber_bird/ui/pages/category-page.dart';
import 'package:amber_bird/ui/pages/home-page.dart';
import 'package:amber_bird/ui/pages/login-page.dart';
import 'package:amber_bird/ui/pages/main-page.dart';
import 'package:amber_bird/ui/pages/product-page.dart';
import 'package:amber_bird/ui/pages/profile-page.dart';
import 'package:amber_bird/ui/pages/sign-up.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePageModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => HomePage(), children: [
      ChildRoute('/main', child: (_, args) => MainPage()),
      ChildRoute(
        '/product',
        child: (_, args) => ProductPage(search: true, word: args),
      ),
      ChildRoute('/category', child: (_, args) => CategoryPage()),
      ChildRoute('/login', child: (_, args) => LoginPageWidget()),
      ChildRoute('/profile', child: (_, args) => ProfilePage()),
      ChildRoute('/cart', child: (_, args) => CartPage()),
      ChildRoute('/signup', child: (_, args) => SignUp()),
    ]),
  ];
}
