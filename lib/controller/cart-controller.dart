import 'dart:developer';
import 'dart:ffi';

import 'package:amber_bird/data/cart-product.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxMap<String, CartProduct> cartProducts = Map<String, CartProduct>().obs;
  @override
  void onInit() {
    super.onInit();
  }

  void addToCart(ProductSummary? product, String refId, String addedFrom,int? addQuantity) {
 
    var getData = cartProducts[refId];
    int quantity = 0 + addQuantity!;
    double price = (product!.varient!.price!.offerPrice).toDouble();
    if (getData != null) {
      quantity = getData!.quantity!;
      quantity = quantity + addQuantity!;
      price = price * quantity;
    }

    List<ProductSummary> li = [];
    li.add(product!);
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

   bool checkProductInCart(key){
    if(cartProducts[key] != null){
      return true;
    }else{
      return false;
    }
  }

  int getCurrentQuantity(key) {
    if(cartProducts[key] != null){
      return cartProducts[key]!.quantity!;
    }else{
      return 0;
    }
    
  }
}
