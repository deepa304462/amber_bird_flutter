import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/open-container/open_container_wrapper.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  final WishlistController wishlistController = Get.find();
  Widget _gridItemBody(ProductSummary product, BuildContext context) {
    return Column(
      children: [
        product.images!.isNotEmpty
            ? InkWell(
                onTap: () {
                  Modular.to.pushNamed('product/${product.id}');
                },
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.network(
                    '${ClientService.cdnUrl}${product!.images![0]}',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
            : const SizedBox(
                child: Text('Empty Image'),
              ),
        _gridItemFooter(product, context)
      ],
    );
  }

  Widget _gridItemHeader(ProductSummary product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() {
          return Visibility(
            visible: checkFavVisibility(),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: wishlistController.checkIfProductWishlist(product.id)
                    ? Colors.redAccent
                    : const Color(0xFFA6A3A0),
              ),
              onPressed: () =>
                  {wishlistController.addToWishlist(product.id, product)},
            ),
          );
        }),

        // }),
      ],
    );
  }

  Widget _gridItemFooter(ProductSummary product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      // margin: const EdgeInsets.only(left: 3, right: 3),
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
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('${product!.varient!.weight}'),
                  Text(
                    '${CodeHelp.formatUnit(product!.varient!.unit)}',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  )
                ],
              ),
              checkPriceVisibility()
                  ? addedFrom == 'DEAL'
                      ? PriceTag(dealPrice!.offerPrice!.toString(),
                          dealPrice!.actualPrice!.toString())
                      : PriceTag(product.varient!.price!.offerPrice!.toString(),
                          product.varient!.price!.actualPrice!.toString())
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            _gridItemBody(product!, context),
            _gridItemHeader(product!),
            Positioned(
              right: 0,
              top: 50,
              child: Visibility(
                visible: checkBuyProductVisibility(),
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade900,
                  radius: 20,
                  child: IconButton(
                    constraints: const BoxConstraints(),
                    color: Colors.white,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        useRootNavigator: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        elevation: 3,
                        builder: (context) {
                          // return _bottomSheetAddToCart(product, context);
                          return DealBottomDrawer([product!], refId, addedFrom,
                              dealPrice, product!.name);
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  checkFavVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }

  checkBuyProductVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }

  checkPriceVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }

  checkDealTimeoutVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }
}
