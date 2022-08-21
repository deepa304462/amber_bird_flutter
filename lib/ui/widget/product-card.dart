import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/deal_price.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/open_container_wrapper.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final ProductSummary? product;
  final String? refId;
  final String? addedFrom;
  final Price? dealPrice;
  ProductCard(this.product, this.refId, this.addedFrom, this.dealPrice,
      {super.key});

  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  Widget _gridItemBody(ProductSummary product, BuildContext context) {
    return Column(
      children: [
        OpenContainerWrapper(
          product: product,
          refId: product.id,
          addedFrom: 'DIRECTLY',
          child: Image.network('${ClientService.cdnUrl}${product!.images![0]}',
              fit: BoxFit.fill),
        ),
        _gridItemFooter(product, context)
      ],
    );
  }

  Widget _gridItemHeader(ProductSummary product) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: true,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              width: 80,
              height: 30,
              alignment: Alignment.center,
              child: const Text(
                "2hrs left",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite,
              // color: myController.filteredProducts[index].isLiked
              //     ? Colors.redAccent
              //     : const Color(0xFFA6A3A0),
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  Widget _gridItemFooter(ProductSummary product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      // margin: const EdgeInsets.only(left: 3, right: 3),
      height: 55,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product!.name!.defaultText!.text ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              addedFrom == 'DEAL'
                  ? Text(
                      "\$${dealPrice!.offerPrice}",
                      style: TextStyles.bodyFont,
                    )
                  : Text(
                      "\$${product.varient!.price!.offerPrice}",
                      style: TextStyles.bodyFont,
                    ),
              const SizedBox(width: 3),
              addedFrom == 'DEAL'
                  ? Visibility(
                      visible: dealPrice!.actualPrice != null ? true : false,
                      child: Text(
                        "\$${dealPrice!.actualPrice.toString()}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Visibility(
                      visible: product!.varient!.price!.actualPrice != null
                          ? true
                          : false,
                      child: Text(
                        "\$${product!.varient!.price!.actualPrice.toString()}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              Spacer(),
              IconButton(
                padding: const EdgeInsets.all(1),
                constraints: const BoxConstraints(),
                onPressed: () {
                  showModalBottomSheet<void>(
                    // context and builder are
                    // required properties in this widget
                    context: context,
                    builder: (BuildContext context) {
                      return _bottomSheetAddToCart(product, context);
                    },
                  );
                  // cartController.addToCart(product!, refId!, addedFrom!);
                },
                icon: const Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetAddToCart(ProductSummary product, BuildContext context) {
    ProductSummary? p = ProductSummary.fromMap(product.toMap());
    if (addedFrom == 'DEAL') {
      // var curProduct = product.toMap();
      // ProductSummary? p=ProductSummary.fromMap(curProduct);
      p!.varient!.price = dealPrice;
      inspect(p);
      inspect(product);
    }
    return SizedBox(
      height: 300,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            '${ClientService.cdnUrl}${p!.images![0]}',
            width: 200,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${p.name!.defaultText!.text}',
                style: TextStyles.bodyFont,
              ),
              SizedBox(height: 5),
              Text('${p.varient!.weight!} ${p.varient!.unit!}'),
              Text('\$${p.varient!.price!.offerPrice!}'),
              Text(
                '\$${p.varient!.price!.actualPrice!}',
                style: TextStyles.prieLinThroughStyle,
              ),
              GetX<CartController>(builder: (cController) {
                return cController.checkProductInCart(refId)
                    ? Row(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              if (stateController.isLogin.value) {
                                cController.addToCart(
                                    p, refId!, addedFrom!, -1);
                              } else {
                                stateController.setCurrentTab(3);
                                var showToast = snackBarClass.showToast(
                                    context, 'Please Login to preoceed');
                              }
                              // cController.addToCart(p, refId!, addedFrom!, -1);
                            },
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.black),
                          ),
                          Text(
                              cController.getCurrentQuantity(refId).toString()),
                          IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              if (stateController.isLogin.value) {
                                cController.addToCart(p, refId!, addedFrom!, 1);
                              } else {
                                stateController.setCurrentTab(3);
                                var showToast = snackBarClass.showToast(
                                    context, 'Please Login to preoceed');
                              }
                              // cController.addToCart(p, refId!, addedFrom!, 1);
                            },
                            icon: const Icon(Icons.add_circle_outline,
                                color: Colors.black),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primeColor,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 50, vertical: 15),
                            textStyle: TextStyles.bodyWhite),
                        onPressed: p!.varient!.currentStock > 0
                            ? () {
                                if (stateController.isLogin.value) {
                                  cartController.addToCart(
                                      p, refId!, addedFrom!, 1);
                                } else {
                                  stateController.setCurrentTab(3);
                                  var showToast = snackBarClass.showToast(
                                      context, 'Please Login to preoceed');
                                }
                              }
                            : () {
                                print(
                                    'nnnnnnnnnnnnnnnnnnnnnnnnnnnn${stateController.isLogin.value}');
                                if (stateController.isLogin.value) {
                                  cartController.addToCart(
                                      p, refId!, addedFrom!, 1);
                                } else {
                                  stateController.setCurrentTab(3);
                                  var showToast = snackBarClass.showToast(
                                      context, 'Please Login to preoceed');
                                }
                              },
                        child: Text("Add to cart",
                            style: TextStyles.addTocartText),
                      );
              }),
            ],
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(5),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(15.0),
        child: GridTile(
          header: _gridItemHeader(product!),
          child: _gridItemBody(product!, context),
        ),
      ),
    );
  }
}
