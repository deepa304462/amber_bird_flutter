import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/ui/widget/appBar/app-bar.dart';
import 'package:amber_bird/ui/widget/bottom_nav.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' as routerOut;
import 'package:get/get.dart';

PreferredSize _appBar(address) {
  // var dropdownvalue;
  return PreferredSize(
    preferredSize: const Size.fromHeight(100),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.lightGrey),
              child: Row(children: [
                IconButton(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: const Icon(Icons.location_city, color: Colors.black),
                ),
                Text(address != '' ? address.substring(0, 20) : 'Location')
              ]),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.lightGrey),
              child: IconButton(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(Icons.shopping_basket, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

// class _HomePageState extends State<HomePage> {
class HomePage extends StatelessWidget {
  // to keep track of active tab index
  // Controller myController = Get.put(Controller(), tag: 'mycontroller');
  final Controller myController = Get.put(Controller());

  final WishlistController wishlistController = Get.put(WishlistController());
  final CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        myController.backPressed();
        return myController.backButtonPress.value == 2
            ? Future.value(true)
            : Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          titleSpacing: 5,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: AppBarWidget(),
        ),
        body: const routerOut.RouterOutlet(),
        bottomNavigationBar: GetX<Controller>(builder: (mcontroller) {
          return BottomNav(
            index: mcontroller.currentTab.toInt(),
            backgroundColor: Colors.white,
            showElevation: true,
            navBarHeight: 50.0,
            // radius: 30.0,
            onTap: (i) {
              mcontroller.setCurrentTab(i);
            },
            items: [
              BottomNavItem(
                  // imgIcon:
                  //     'https://cdn2.sbazar.app/383ba026-222a-4a16-8c24-b6f7f7227630',
                  icon: Icons.home,
                  label: "Home",
                  selectedColor: Colors.red.shade900),
              BottomNavItem(
                  icon: Icons.manage_search,
                  suffix: '',
                  label: "Search",
                  selectedColor: Colors.red.shade900),
              BottomNavItem(
                  icon: Icons.storefront_sharp,
                  suffix: '',
                  label: "Category",
                  selectedColor: Colors.red.shade900),
              BottomNavItem(
                  icon: Icons.shopping_cart,
                  label: "Cart",
                  selectedColor: Colors.red.shade900),
              BottomNavItem(
                  icon: Icons.account_circle,
                  suffix: '',
                  label: "Profile",
                  selectedColor: Colors.red.shade900),
            ],
          );
        }),
      ),
    );
  }
}
