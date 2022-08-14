import 'dart:ffi';
 
import 'package:amber_bird/data/deal_product/product.dart'; 
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var currentTab = 0.obs;

  RxList<ProductSummary> filteredProducts = <ProductSummary>[].obs;
  RxList<ProductSummary> cartProducts = <ProductSummary>[].obs;
  RxInt totalPrice = 0.obs;
  RxInt currentBottomNavItemIndex = 0.obs;
  RxInt productImageDefaultIndex = 0.obs;

  @override
  void onInit() {
    changeTab(currentTab.toInt());
    super.onInit();
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

  changeTab(currentTab) {
    switch (currentTab) {
      case 0:
        Modular.to.navigate('/main');
        break;
      case 1:
        Modular.to.navigate('/category');
        break;
      case 2:
        Modular.to.navigate('/cart');
        break;
      case 3:
        Modular.to.navigate('/login');
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
