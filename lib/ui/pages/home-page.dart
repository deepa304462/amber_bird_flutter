import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/appBar/app-bar.dart';
import 'package:amber_bird/ui/widget/bottom_nav.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' as routerOut;
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../helpers/controller-generator.dart';

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
  final Controller myController = Get.find();

  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxString showCaseData = 'false'.obs;
  final AppbarScrollController appbarScrollController = Get.find();
  getShowCaseVal(BuildContext context) async {
    showCaseData.value = await SharedData.read('showCaseDone') ?? '';
    if (showCaseData.value != 'true') {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([
                myController.showKeyMap['category']!.key,
                myController.showKeyMap['brand']!.key,
                // myController.showKeyMap['pincode']!.key,
                myController.showKeyMap['refer']!.key,
                myController.showKeyMap['coinWallet']!.key,
              ]));
      SharedData.save(true.toString(), 'showCaseDone');
    }
  }

  @override
  Widget build(BuildContext context) {
    getShowCaseVal(context);

    return WillPopScope(
      onWillPop: () {
        myController.backPressed();
        return myController.backButtonPress.value == 2
            ? Future.value(true)
            : Future.value(false);
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: AppColors.commonBgColor,
          appBar: appbarScrollController.shrinkappbar.value
              ? AppBar(
                  toolbarHeight: 50,
                  titleSpacing: 5,
                  backgroundColor: Colors.white,
                  // automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: AppBarShrinkWidget(),
                )
              : AppBar(
                  toolbarHeight: 90,
                  titleSpacing: 5,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: AppBarWidget(),
                ),
          body: Stack(
            children: [
              IgnorePointer(
                  ignoring: myController.showLoader.value,
                  child: const routerOut.RouterOutlet()),
              Obx(
                () => myController.showLoader.value
                    ? const LoadingWithLogo()
                    : const SizedBox(),
              )
            ],
          ),
          bottomNavigationBar: GetX<Controller>(builder: (mcontroller) {
            return BottomNav(
              index: mcontroller.currentTab.toInt(),
              backgroundColor: Colors.white,
              showElevation: true,
              navBarHeight: 45.0,
              // radius: 30.0,
              onTap: (i) {
                mcontroller.setCurrentTab(i);
              },
              items: [
                BottomNavItem(
                    imgIcon: 'assets/insidelogo.png',
                    icon: Icons.home,
                    label: "Home",
                    selectedColor: Colors.red.shade900,
                    givenKey: myController.showKeyMap['home']!),
                BottomNavItem(
                    icon: Icons.category,
                    suffix: '',
                    label: "Category",
                    selectedColor: Colors.red.shade900,
                    givenKey: myController.showKeyMap['category']!),
                BottomNavItem(
                    icon: Icons.storefront_sharp,
                    suffix: 'Shop',
                    label: "",
                    selectedColor: Colors.red.shade900,
                    givenKey: myController.showKeyMap['brand']!),
                BottomNavItem(
                    icon: Icons.shopping_cart,
                    label: "Cart",
                    selectedColor: Colors.red.shade900,
                    givenKey: myController.showKeyMap['cart']!),
                BottomNavItem(
                    icon: Icons.account_circle,
                    suffix: '',
                    label: "Profile",
                    selectedColor: Colors.red.shade900,
                    givenKey: myController.showKeyMap['profile']!),
              ],
            );
          }),
        ),
      ),
    );
  }
}
