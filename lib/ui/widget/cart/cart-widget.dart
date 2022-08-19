import 'package:amber_bird/controller/cart-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return cartController.cartProducts.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: cartController.cartProducts.length,
            itemBuilder: (_, index) {
              var currentKey =
                  cartController.cartProducts.value.keys.elementAt(index);
              // var currentProduct =
              //     cartController.cartProducts.value[currentKey]!.product;
              print(currentKey);
              // print(currentProduct);
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        print(
                            "Container clicked ${index}${cartController.cartProducts[currentKey]}");
                        // selectedCatergory =
                        //     categoryController.categoryList[index];
                        // categoryController.getSubCategory(
                        //     categoryController.categoryList[index].id);
                      },
                      child: Text(cartController.cartProducts[currentKey]!.quantity!.toString()),
                    ),
                              cartController.cartProducts.value[currentKey]!.product!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: cartController.cartProducts.value[currentKey]!.product!.length,
                        itemBuilder: (_, pIndex) {
                          var currentProduct = cartController.cartProducts.value[currentKey]!.product![pIndex];
                          return Text(currentProduct.name!.defaultText!.text ?? '');
                        }) : SizedBox()
                  ],
                ),
              );
            },
          )
        : const SizedBox();
  }
}
