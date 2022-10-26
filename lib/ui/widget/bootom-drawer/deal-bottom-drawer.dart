import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/name.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealBottomDrawer extends StatelessWidget {
  final List<ProductSummary>? products;
  final String? refId;
  final String? addedFrom;
  final Price? priceInfo;
  final Name? name;
  DealBottomDrawer(
      this.products, this.refId, this.addedFrom, this.priceInfo, this.name,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    final Controller stateController = Get.find();
    final WishlistController wishlistController = Get.find();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .75),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${name!.defaultText!.text}',
                      style: TextStyles.headingFontGray,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: products!.map((product) {
                      product.varient!.price = priceInfo;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ImageBox(
                                      product.images![0],
                                      width: 120,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      textDirection: TextDirection.ltr,
                                      children: [
                                        Visibility(
                                          visible: name!.defaultText!.text !=
                                              product.name!.defaultText!.text,
                                          child: Text(
                                            '${product.name!.defaultText!.text}',
                                            style: TextStyles.headingFont,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Image.network(
                                              '${ClientService.cdnUrl}${product.category!.logoId}',
                                              height: 20,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${product.category!.name!.defaultText!.text}',
                                              style: TextStyles.subHeadingFont,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Card(
                                                color: Colors.white,
                                                margin: const EdgeInsets.all(5),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                        '${product.varient!.weight!} ${CodeHelp.formatUnit(product.varient!.unit)}'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                    top: -12,
                                    left: -12,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: wishlistController
                                                .checkIfProductWishlist(
                                                    product.id)
                                            ? Colors.redAccent
                                            : AppColors.grey,
                                      ),
                                      onPressed: () => {
                                        wishlistController.addToWishlist(
                                            product.id, product)
                                      },
                                    ))
                              ],
                            ),
                            Text(
                              'Description',
                              style: TextStyles.bodyFontBold,
                            ),
                            Text(
                              product.description!.defaultText!.text ?? '',
                              style: TextStyles.bodyFont,
                              textAlign: TextAlign.justify,
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AppBar(
                  shape: Border(top: BorderSide(color: AppColors.primeColor)),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceTag(priceInfo!.offerPrice.toString(),
                          priceInfo!.actualPrice.toString()),
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
                                            refId!,
                                            addedFrom!,
                                            -1,
                                            priceInfo,
                                            products![0], []);
                                      } else {
                                        stateController.setCurrentTab(3);
                                        var showToast = snackBarClass.showToast(
                                            context,
                                            'Please Login to preoceed');
                                      }
                                      // cController.addToCart(p, refId!, addedFrom!, -1);
                                    },
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.black),
                                  ),
                                  Text(cController
                                      .getCurrentQuantity(refId)
                                      .toString()),
                                  IconButton(
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      if (stateController.isLogin.value) {
                                        cController.addToCart(
                                            refId!,
                                            addedFrom!,
                                            1,
                                            priceInfo,
                                            products![0],
                                            null);
                                      } else {
                                        stateController.setCurrentTab(3);
                                        snackBarClass.showToast(context,
                                            'Please Login to preoceed');
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
                                    textStyle: TextStyles.bodyWhite),
                                onPressed: stateController.isLogin.value
                                    ? () {
                                        if (stateController.isActivate.value) {
                                          if (addedFrom == 'MULTIPRODUCT') {
                                            cartController.addToCart(
                                                refId!,
                                                addedFrom!,
                                                1,
                                                priceInfo,
                                                null,
                                                products);
                                          } else {
                                            cartController.addToCart(
                                                refId!,
                                                addedFrom!,
                                                1,
                                                priceInfo,
                                                products![0],
                                                null);
                                          }
                                        } else {
                                          snackBarClass.showToast(context,
                                              'Your profile is not active yet');
                                        }
                                      }
                                    : () {
                                        stateController.setCurrentTab(3);
                                        snackBarClass.showToast(context,
                                            'Please Login to preoceed');
                                      },
                                child: Text("Add to cart",
                                    style: TextStyles.addTocartText),
                              );
                      }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
