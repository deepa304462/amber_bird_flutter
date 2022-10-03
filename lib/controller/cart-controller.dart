import 'dart:developer';
import 'dart:ffi';

import 'package:amber_bird/data/cart-product.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxMap<String, CartProduct> cartProducts = <String, CartProduct>{}.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void addToCart(List<ProductSummary>? product, String refId, String addedFrom,
      int? addQuantity, Price? priceInfo) {
    var getData = cartProducts[refId];
    int quantity = 0 + addQuantity!;
    double price = (priceInfo!.offerPrice).toDouble();
    if (getData != null) {
      quantity = getData!.quantity!;
      quantity = quantity + addQuantity!;
      price = price * quantity;
    }

    List<ProductSummary> li = [];
    li.addAll(product!);
    inspect(product);
    CartProduct cartRow = CartProduct.fromMap({
      'product': li,
      'quantity': quantity,
      'refId': refId,
      'addedFrom': addedFrom,
      'totalPrice': price.toString()
    });

    cartProducts[refId] = cartRow;

    // cartProducts.assignAll(cartProducts.distinctBy((item) => item));
    // calculateTotalPrice();
  }

  currentCount(String refId) {
    if (checkProductInCart(refId)) {
      return cartProducts[refId]!.quantity;
    } else {
      return 0;
    }
  }

  bool checkProductInCart(key) {
    if (cartProducts[key] != null) {
      return true;
    } else {
      return false;
    }
  }

  int getCurrentQuantity(key) {
    if (cartProducts[key] != null) {
      return cartProducts[key]!.quantity!;
    } else {
      return 0;
    }
  }
}
