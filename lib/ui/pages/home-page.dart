import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/appBar/app-bar.dart';
import 'package:amber_bird/ui/widget/bottom_nav.dart';
import 'package:amber_bird/ui/widget/search-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' as routerOut;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

PreferredSize _appBar(address) {
  var dropdownvalue;
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
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80), child: appBarWidget()),
      body: GetX<Controller>(builder: (mController) {
        print(mController.activePageName);
        print(mController.showSearch());
        if (mController.showSearch() == true) {
          return Stack(alignment: AlignmentDirectional.topCenter, children: [
            SearchWidget(),
            const Padding(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: routerOut.RouterOutlet())
          ]);
        } else {
          return routerOut.RouterOutlet();
        }
      }),
      bottomNavigationBar: GetX<Controller>(
          // init: myController,
          builder: (mcontroller) {
        return BottomNav(
          index: mcontroller.currentTab.toInt(),
          backgroundColor: Colors.white,
          showElevation: true,
          navBarHeight: 75.0,
          radius: 30.0,
          onTap: (i) {
            mcontroller.setCurrentTab(i);
          },
          items: [
            BottomNavItem(
                imgIcon:
                    'https://cdn2.sbazar.app/383ba026-222a-4a16-8c24-b6f7f7227630',
                icon: Icons.home,
                label: "Home",
                selectedColor: Colors.red.shade900),
            BottomNavItem(
                icon: Icons.category,
                suffix: '',
                label: "Category",
                selectedColor: Colors.green),
            BottomNavItem(
                icon: Icons.shopping_bag,
                label: "Search",
                // suffix: cartController!.cartProducts!.length.toString() ?? '0',
                selectedColor: Colors.amber.shade800),
            BottomNavItem(
                icon: Icons.account_circle,
                suffix: '',
                label: "Profile",
                selectedColor: Colors.blue),
          ],
        );
      }),
    );
  }
}
