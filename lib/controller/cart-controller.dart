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

  void addToCart(ProductSummary? product, String refId, String addedFrom) {
    // CartProduct cartRow;
    // final index =
    //     cartProducts.value.indexWhere((element) => element.id == product!.id);
    // if (index >= 0) {
    //   List<CartProduct> cartProductsLocal = cartProducts.value;
    //   print('Using indexWhere: ${cartProducts.value[index]}');
    //   // foods.firstWhere((element) => element.id == searchedId) = food;
    //   print('Using20e: ${cartProducts.value[index].quantity}');
    //   cartProducts.value[index].quantity =
    //       cartProducts.value[index].quantity ?? 0 + 1;
    //   cartRow = CartProduct.fromMap({
    //     'product': cartProducts.value[index].product!.toMap(),
    //     'quantity': cartProducts.value[index].quantity ?? 0 + 1,
    //     'id': cartProducts.value[index]!.id
    //   });
    //   cartProducts[index] = cartRow;
    //   print('Using20e3: ${cartProducts.value[index].quantity}');
    //   print('Using indexWhereeeeeeeeeeeeeeeeeee: ${cartProducts.value[index]}');

    // } else {
    //   cartRow = CartProduct.fromMap(
    //       {'product': product!.toMap(), 'quantity': 1, 'id': product!.id});
    //   // product.quantity++;
    //   cartProducts.add(cartRow);
    // }

    // var key= '${product!.id}@${product!.varient!.varientCode}';

    var getData = cartProducts[refId];
    int quantity = 1;
    double price = (product!.varient!.price!.offerPrice).toDouble();
    if (getData != null) {
      quantity = getData!.quantity!;
      quantity++;
      price = price * quantity;
    }

    List<ProductSummary> li = [];
    li.add(product!);

    CartProduct cartRow = CartProduct.fromMap({
      'product': li,
      'quantity': quantity,
      'refId': refId,
      'addedFrom': addedFrom,
      'totalPrice': price.toString()
    });

    cartProducts[refId] = cartRow;
    inspect(cartProducts);
    // cartProducts.assignAll(cartProducts.distinctBy((item) => item));
    // calculateTotalPrice();
  }
}
