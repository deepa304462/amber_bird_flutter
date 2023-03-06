import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../helpers/controller-generator.dart';

class ProductBottomDrawer extends StatelessWidget {
  final String? pId;
  ProductBottomDrawer(this.pId, {super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController =
        ControllerGenerator.create(CartController(), tag: 'cartController');
    final Controller stateController = Get.find();
    final WishlistController wishlistController = Get.find();
    ProductController productController;
    if (Get.isRegistered<ProductController>()) {
      productController = Get.find<ProductController>(tag: pId ?? '');
    } else {
      productController = Get.put(ProductController(pId ?? ''), tag: pId ?? "");
    }
    return Obx(() => productController.product.value.id != null
        ? Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .75),
            child: SingleChildScrollView(
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
                              '${productController.product.value.name!.defaultText!.text}',
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
                          child: Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
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
                                            productController
                                                .product.value.images![0],
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
                                                visible: productController
                                                        .product
                                                        .value
                                                        .name!
                                                        .defaultText!
                                                        .text !=
                                                    productController
                                                        .product
                                                        .value
                                                        .name!
                                                        .defaultText!
                                                        .text,
                                                child: Text(
                                                  '${productController.product.value..name!.defaultText!.text}',
                                                  style: TextStyles.headingFont,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  ImageBox(
                                                    productController
                                                        .product
                                                        .value
                                                        .category!
                                                        .logoId!,
                                                    width: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${productController.product.value.category!.name!.defaultText!.text}',
                                                    style: TextStyles
                                                        .subHeadingFont,
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
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Center(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: productVarientView(
                                                                productController
                                                                        .product
                                                                        .value
                                                                        .varients ??
                                                                    [],
                                                                productController
                                                                    .activeIndexVariant
                                                                    .value,
                                                                productController)
                                                            // Text(
                                                            //                                                     '${productController.product.value.varient!.weight!} ${CodeHelp.formatUnit(productController.product.value.varient!.unit)}'),
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
                                                        productController
                                                            .product.value.id)
                                                ? AppColors.primeColor
                                                : AppColors.grey,
                                          ),
                                          onPressed: () => {
                                            wishlistController.addToWishlist(
                                                productController
                                                    .product.value.id,
                                                productController.product.value,
                                                null,
                                                'PRODUCT')
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Description',
                                    style: TextStyles.bodyFontBold,
                                  ),
                                  Html(
                                    data: productController.product.value
                                            .description!.defaultText!.text ??
                                        '',
                                  ),
                                  const Divider(),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AppBar(
                          shape: Border(
                              top: BorderSide(color: AppColors.primeColor)),
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.white,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PriceTag(
                                  productController
                                      .varient.value.price!.offerPrice
                                      .toString(),
                                  productController
                                      .varient.value.price!.actualPrice
                                      .toString()),
                              cartController.checkProductInCart(
                                      '$pId@${productController.varient.value.varientCode}',
                                      '')
                                  ? Row(
                                      children: [
                                        IconButton(
                                          padding: const EdgeInsets.all(8),
                                          constraints: const BoxConstraints(),
                                          onPressed: () async {
                                            if (stateController.isLogin.value) {
                                              var valid = false;
                                              var msg = 'Something went wrong!';

                                              ProductSummary summary =
                                                  ProductSummary.fromMap({
                                                "name": productController
                                                    .product.value.name!
                                                    .toMap(),
                                                "description": productController
                                                    .product.value.description!
                                                    .toMap(),
                                                "images": productController
                                                    .product.value.images,
                                                "varient": productController
                                                    .varient.value
                                                    .toMap(),
                                                "category": productController
                                                    .product.value.category!
                                                    .toMap(),
                                                "countryCode": productController
                                                    .product.value.countryCode,
                                                "id": productController
                                                    .product.value.id
                                              });
                                              // cartController.addToCart(
                                              //     '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                              //     'PRODUCT',
                                              //     -1,
                                              //     productController
                                              //         .varient.value.price!,
                                              //     summary,
                                              //     null);
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.black),
                                        ),
                                        Text(cartController
                                            .getCurrentQuantity(
                                                '$pId@${productController.varient.value.varientCode}',
                                                '')
                                            .toString()),
                                        IconButton(
                                          padding: const EdgeInsets.all(8),
                                          constraints: const BoxConstraints(),
                                          onPressed: () async {
                                            if (stateController.isLogin.value) {
                                              var valid = false;
                                              var msg = 'Something went wrong!';
                                              ProductSummary summary =
                                                  ProductSummary.fromMap({
                                                "name": productController
                                                    .product.value.name!
                                                    .toMap(),
                                                "description": productController
                                                    .product.value.description!
                                                    .toMap(),
                                                "images": productController
                                                    .product.value.images,
                                                "varient": productController
                                                    .varient.value
                                                    .toMap(),
                                                "category": productController
                                                    .product.value.category!
                                                    .toMap(),
                                                "countryCode": productController
                                                    .product.value.countryCode,
                                                "id": productController
                                                    .product.value.id
                                              });

                                              // cartController.addToCart(
                                              //     '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                              //     'PRODUCT',
                                              //     1,
                                              //     productController
                                              //         .varient.value.price!,
                                              //     summary,
                                              //     null);
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.black),
                                        ),
                                      ],
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primeColor,
                                          textStyle: TextStyles.bodyWhite),
                                      onPressed: stateController.isLogin.value
                                          ? () async {
                                              stateController.showLoader.value =
                                                  true;
                                              bool isCheckedActivate =
                                                  await stateController
                                                      .getUserIsActive();
                                              if (isCheckedActivate) {
                                                var valid = false;
                                                var msg =
                                                    'Something went wrong!';
                                                ProductSummary summary =
                                                    ProductSummary.fromMap({
                                                  "name": productController
                                                      .product.value.name!
                                                      .toMap(),
                                                  "description":
                                                      productController.product
                                                          .value.description!
                                                          .toMap(),
                                                  "images": productController
                                                      .product.value.images,
                                                  "varient": productController
                                                      .varient.value
                                                      .toMap(),
                                                  "category": productController
                                                      .product.value.category!
                                                      .toMap(),
                                                  "countryCode":
                                                      productController.product
                                                          .value.countryCode,
                                                  "id": productController
                                                      .product.value.id
                                                });
                                                // cartController.addToCart(
                                                //     '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                //     'PRODUCT',
                                                //     1,
                                                //     productController
                                                //         .varient.value.price!,
                                                //     summary,
                                                //     null);
                                              } else {
                                                Navigator.of(context).pop();
                                                snackBarClass.showToast(context,
                                                    'Your profile is not active yet');
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            }
                                          : () {
                                              Navigator.of(context).pop();
                                              stateController.setCurrentTab(3);
                                              snackBarClass.showToast(context,
                                                  'Please Login to preoceed');
                                            },
                                      child: Text("Add to cart",
                                          style: TextStyles.addTocartText),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : SizedBox());
  }

  Widget productVarientView(List<Varient> varientList, activeVariant,
      ProductController productController) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: varientList.length,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            var currentVarient = varientList[index];
            return InkWell(
              onTap: () {
                productController.setVarient(currentVarient);
              },
              child: SizedBox(
                height: 50,
                child: Card(
                  color: currentVarient.varientCode ==
                          productController.varient.value.varientCode
                      ? AppColors.primeColor
                      : Colors.white,
                  margin: const EdgeInsets.all(5),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${currentVarient.weight!.toString()} ${CodeHelp.formatUnit(currentVarient.unit!)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: currentVarient.varientCode !=
                                    productController.varient.value.varientCode
                                ? AppColors.primeColor
                                : Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
