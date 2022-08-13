import 'dart:ffi';

import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  
 

  var currentTab = 0.obs;
  // RxList<ProductCategory> categoryList = <ProductCategory>[].obs; //RxList([]);
  // RxList<ProductCategory> subCategoryList = <ProductCategory>[].obs;
  
  RxList<Product> filteredProducts = <Product>[].obs;
  RxList<Product> cartProducts = <Product>[].obs;
  RxInt totalPrice = 0.obs;
  RxInt currentBottomNavItemIndex = 0.obs;
  RxInt productImageDefaultIndex = 0.obs;

  @override
  void onInit() {
    changeTab(currentTab.toInt());
    super.onInit();
  }

  // increment() {
  //   count++;
  // }
  bool isPriceOff(Product product) {
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
    currentTab.value =  (curTab);
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

  // setCategory(cList) {
  //   categoryList = RxList(cList);
  // }

  // setDealProd(cList) {
  //   dealProd = (cList);
  // }

  // setSubCategory(sList) {
  //   subCategoryList = RxList(sList);
  // }



  void switchBetweenProductImages(int index) {
    productImageDefaultIndex.value = index;
  }

  // List<Numerical> sizeType(Product product) {
  //   ProductSizeType? productSize = product.sizes;
  //   List<Numerical> numericalList = [];

  //   if (productSize?.numerical != null) {
  //     for (var element in productSize!.numerical!) {
  //       numericalList.add(Numerical(element.numerical, element.isSelected));
  //     }
  //   }

  //   if (productSize?.categorical != null) {
  //     for (var element in productSize!.categorical!) {
  //       numericalList
  //           .add(Numerical(element.categorical.name, element.isSelected));
  //     }
  //   }

  //   return numericalList;
  // }
}
