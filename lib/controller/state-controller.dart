import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var isLogin = false.obs;
  var currentTab = 0.obs;
  var activePageName = ''.obs;
  var onboardingDone = false.obs;
  var isActivate = false.obs;
  var backButtonPress = 0.obs;
  RxList<ProductSummary> filteredProducts = <ProductSummary>[].obs;
  RxList<ProductSummary> cartProducts = <ProductSummary>[].obs;
  RxInt totalPrice = 0.obs;
  RxInt currentBottomNavItemIndex = 0.obs;
  RxInt productImageDefaultIndex = 0.obs;

  @override
  void onInit() {
    backButtonPress.value = 0;
    getLoginInfo();

    changeTab(currentTab.toInt());
    super.onInit();
  }

  backPressed() {
    backButtonPress.value = backButtonPress.value + 1;
    if (backButtonPress.value < 2) {
      CodeHelp.toast('Press back on more time to exit');
    }
  }

  getLoginInfo() async {
    var onboardLocarl = await (SharedData.read('onboardingDone'));
    bool onboard = onboardLocarl.toString() == 'true';
    onboardingDone.value = onboard;
    var isLoginShared = await (SharedData.read('isLogin'));
    bool b = isLoginShared.toString() == 'true';
    isLogin.value = b;
    var authData = jsonDecode(await (SharedData.read('authData')));
    print('aaaaaaaaa$authData');
    ClientService.token = authData['accessToken'] ?? '';
    isActivate.value = authData['emailVerified'] ?? false;

  }

  logout() {
    isLogin.value = false;
    ClientService.token = '';
    SharedData.save(false.toString(), 'isLogin');
    SharedData.remove('userData');
    SharedData.remove('authData');
    SharedData.remove('ProfileAuthData');
    changeTab(currentTab.toInt());
  }

  bool isPriceOff(ProductSummary product) {
    if (product.varient!.price!.offerPrice != null) {
      return true;
    } else {
      return false;
    }
  }

  void calculateTotalPrice() {
    totalPrice.value = 0;
    for (var element in cartProducts) {
      if (isPriceOff(element)) {
        totalPrice.value += (element.varient!.price!.offerPrice!)
            as int; //element.quantity * element.off!;
      } else {
        totalPrice.value += element.varient!.price!.offerPrice
            as int; //element.quantity * element.price;
      }
    }
  }

  setCurrentTab(curTab) {
    currentTab.value = (curTab);
    changeTab(currentTab.toInt());
  }

  bool showSearch() {
    print(activePageName);
    if (activePageName.value == 'main' ||
        activePageName.value == 'category' ||
        activePageName.value == 'search') {
      return true;
    } else {
      return false;
    }
  }

  navigateToUrl(url) {
    if (url == '/home/cart') {
      activePageName.value == 'cart';
      Modular.to.navigate('/home/cart');
    }
  }

  changeTab(currentTab) {
    switch (currentTab) {
      case 0:
        activePageName.value = 'main';
        Modular.to.navigate('/home/main');
        break;
      case 1:
        activePageName.value = 'category';
        Modular.to.navigate('/home/category');
        break;
      case 2:
        activePageName.value = 'search';
        Modular.to.navigate('/home/search');
        break;
      case 3:
        if (isLogin.value) {
          activePageName.value = 'profile';
          Modular.to.navigate('/home/profile');
        } else {
          activePageName.value = 'login';
          Modular.to.navigate('/home/login');
        }

        break;
    }
  }

  addToCart(product) {
    product.quantity++;
    cartProducts.add(product);
    // cartProducts.assignAll(cartProducts.distinctBy((item) => item));
    calculateTotalPrice();
  }

  void switchBetweenProductImages(int index) {
    productImageDefaultIndex.value = index;
  }
}
