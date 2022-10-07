import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/open-container/open_container_wrapper.dart';
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
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      fit: StackFit.passthrough,
      children: [
        Column(
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
        ),
        Positioned(
          bottom: 60,
          right: 0,
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
                    // context and builder are
                    // required properties in this widget
                    context: context,
                    useRootNavigator: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    elevation: 3,
                    builder: (context) {
                      // return _bottomSheetAddToCart(product, context);
                      return DealBottomDrawer(
                          [product], refId, addedFrom, dealPrice, product.name);
                    },
                  );
                  // cartController.addToCart(product!, refId!, addedFrom!);
                },
                icon: Icon(
                  Icons.add,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _gridItemHeader(ProductSummary product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: checkDealTimeoutVisibility(),
          child: Card(
            clipBehavior: Clip.hardEdge,
            color: Colors.red.shade800,
            margin: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Text(
                "2hrs left",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        // GetX<WishlistController>(builder: (wController) {
        //   return
        Obx(() {
          print(wishlistController.wishlistProducts);
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
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              checkPriceVisibility()
                  ? Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        addedFrom == 'DEAL'
                            ? Text("\$${dealPrice!.offerPrice}",
                                style: TextStyles.bodyFontBold)
                            : Text(
                                "\$${product.varient!.price!.offerPrice}",
                                style: TextStyles.bodyFontBold,
                              ),
                        const SizedBox(width: 3),
                        addedFrom == 'DEAL'
                            ? Visibility(
                                visible: dealPrice!.actualPrice != null
                                    ? true
                                    : false,
                                child: Text(
                                  "\$${dealPrice!.actualPrice.toString()}",
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Visibility(
                                visible:
                                    product!.varient!.price!.actualPrice != null
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
                      ],
                    )
                  : const SizedBox(),
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
              )
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
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          children: [
            _gridItemHeader(product!),
            _gridItemBody(product!, context),
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
