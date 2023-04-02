import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';

class ProductDetailScreen extends StatelessWidget {
  // final PageController _pageController = PageController(initialPage: 0);
  // final Controller myController = Get.put(Controller(), tag: 'mycontroller');
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();
  LocationController locationController = Get.find();
  final AppbarScrollController appbarScrollController = Get.find();
  final String? pId;
  // final Price? dealPrice;
  final String? refId;
  final String? addedFrom;

  ProductDetailScreen(this.pId, this.refId, this.addedFrom, {Key? key});

  Widget productPageView(
      Product product, double width, double height, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child:
          ImageSlider(product.images!, MediaQuery.of(context).size.width * .8),
    );
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
                        '${currentVarient.weight!} ${CodeHelp.formatUnit(currentVarient.unit!)}',
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final ProductController productController =
        Get.put(ProductController(pId ?? ''), tag: pId ?? "");
    return Obx(() => productController.product.value.id != null
        ? Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .32,
                      child: productPageView(productController.product.value,
                          width, height, context),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2.0,
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                detailsHead(productController),
                                Text(
                                  productController.product.value.name!
                                          .defaultText!.text ??
                                      '',
                                  style: TextStyles.headingFont
                                      .copyWith(color: AppColors.primeColor),
                                ),
                                const SizedBox(height: 4),
                                productVarientView(
                                    productController.product.value.varients ??
                                        [],
                                    productController.activeIndexVariant.value,
                                    productController),
                                const SizedBox(height: 5),
                                soldFrom(productController.product.value),
                                const SizedBox(height: 5),
                                const Divider(),
                                deliveryTo(),
                                const Divider(),
                                specification(productController),
                                tags(productController.product.value, context),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primeColor,
                          textStyle:
                              TextStyles.body.copyWith(color: AppColors.white)),
                      onPressed: productController
                                  .product.value.varients![0].currentStock >
                              0
                          ? () {}
                          : () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${CodeHelp.euro}${productController.varient.value.price!.actualPrice!.toString()}",
                                    style: TextStyles.headingFont,
                                  )
                                  //  PriceTag(
                                  //             productController
                                  //                 .varient.value.price!.offerPrice
                                  //                 .toString(),
                                  //             productController
                                  //                 .varient.value.price!.actualPrice
                                  //                 .toString()),
                                  ),
                            ),
                            Obx(() {
                              ProductSummary summary = ProductSummary.fromMap({
                                "name": productController.product.value.name!
                                    .toMap(),
                                "description": productController
                                    .product.value.description!
                                    .toMap(),
                                "images":
                                    productController.product.value.images,
                                "varient":
                                    productController.varient.value.toMap(),
                                "category": productController
                                    .product.value.category!
                                    .toMap(),
                                "countryCode":
                                    productController.product.value.countryCode,
                                "id": productController.product.value.id
                              });
                              return cartController.checkProductInCart(
                                      '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                      addedFrom)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          padding: const EdgeInsets.all(0),
                                          constraints: const BoxConstraints(),
                                          onPressed: ()async {
                                            stateController.showLoader.value =
                                                true;
                                            if (stateController.isLogin.value) {
                                              await cartController.addToCart(
                                                  '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                  addedFrom!,
                                                  -1,
                                                  productController
                                                      .varient.value.price!,
                                                  summary,
                                                  null,
                                                  null,
                                                  null,
                                                  productController
                                                      .varient.value);
                                            } else {
                                              stateController.setCurrentTab(3);
                                              var showToast =
                                                  snackBarClass.showToast(
                                                      context,
                                                      'Please login to proceed');
                                            }
                                            stateController.showLoader.value =
                                                false;
                                            // cController.addToCart(p, refId!, addedFrom!, -1);
                                          },
                                          icon: const Icon(
                                              Icons.remove_circle_outline,
                                              size: 25,
                                              color: Colors.white),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            cartController
                                                .getCurrentQuantity(
                                                    '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                    '')
                                                .toString(),
                                            style: TextStyles.titleFont
                                                .copyWith(
                                                    color: AppColors.white)
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          padding: const EdgeInsets.all(0),
                                          constraints: const BoxConstraints(),
                                          onPressed: () async{
                                            stateController.showLoader.value =
                                                true;
                                            if (stateController.isLogin.value) {
                                             await cartController.addToCart(
                                                  '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                  addedFrom!,
                                                  1,
                                                  productController
                                                      .varient.value.price!,
                                                  summary,
                                                  null,
                                                  null,
                                                  null,
                                                  productController
                                                      .varient.value);
                                            } else {
                                              stateController.setCurrentTab(3);
                                              snackBarClass.showToast(context,
                                                  'Please Login to preoceed');
                                            }
                                            stateController.showLoader.value =
                                                false;
                                            // cController.addToCart(p, refId!, addedFrom!, 1);
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline,
                                              size: 25,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        stateController.showLoader.value = true;
                                        if (stateController.isLogin.value) {
                                          bool isCheckedActivate =
                                              await stateController
                                                  .getUserIsActive();
                                          if (isCheckedActivate) {
                                           await cartController.addToCart(
                                                '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                addedFrom!,
                                                1,
                                                productController
                                                    .varient.value.price!,
                                                summary,
                                                null,
                                                null,
                                                null,
                                                productController
                                                    .varient.value);
                                          } else {
                                            // Navigator.of(context).pop();
                                            // ignore: use_build_context_synchronously
                                            snackBarClass.showToast(context,
                                                'Your profile is not active yet');
                                          }
                                        } else {
                                          stateController.setCurrentTab(3);
                                          var showToast =
                                              snackBarClass.showToast(context,
                                                  'Please Login to preoceed');
                                        }
                                        stateController.showLoader.value =
                                            false;
                                      },
                                      child: Text("Add to cart",
                                          style: TextStyles.titleFont.copyWith(
                                              color: AppColors.white)),
                                    );
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : const Center(
            child: Text("Loading"),
          ));
  }

  deliveryTo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ship to Your address, ${locationController.addressData.value.zipCode ?? ' '}',
          style: TextStyles.titleFont,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Free shipping over ${CodeHelp.euro}10',
          style: TextStyles.titleFont,
        ),
        const Text(
          'Policy Details',
          style: TextStyle(decoration: TextDecoration.underline, fontSize: 18),
        )
      ],
    );
  }

  productCategory(Product value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ImageBox(
                  value.category!.logoId!,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${value.category!.name!.defaultText!.text}',
                style: TextStyles.body,
              )
            ],
          ),
        ],
      ),
    );
  }

  soldFrom(Product value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sold by Sbazar GmBH',
          style: TextStyles.headingFont.copyWith(color: AppColors.grey),
        ),
        const SizedBox(
          height: 5,
        ),
        ImageBox(
          '383ba026-222a-4a16-8c24-b6f7f7227630',
          height: 50,
          width: 50,
        )
      ],
    );
  }

  specification(ProductController productController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Specification",
          style: TextStyles.titleFont..copyWith(color: AppColors.primeColor),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            columnWidths: const {
              0: FractionColumnWidth(.30),
            },
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              TableRow(children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Product category',
                        style: TextStyles.bodyFontBold,
                      ),
                    )),
                TableCell(
                  child: productCategory(productController.product.value),
                )
              ]),
              TableRow(children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Details',
                        style: TextStyles.bodyFontBold,
                      ),
                    )),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Html(
                      data: productController
                              .product.value.description!.defaultText!.text ??
                          '',
                    ),
// Text(
//                       productController
//                               .product.value.description!.defaultText!.text ??
//                           '',
//                       style: TextStyles.body,
//                       textAlign: TextAlign.justify,
//                     ),
                  ),
                )
              ]),
              TableRow(children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Weight',
                        style: TextStyles.bodyFontBold,
                      ),
                    )),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      productController.varient.value.weight.toString() +
                          CodeHelp.formatUnit(
                              productController.varient.value.unit),
                      style: TextStyles.body,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                )
              ])
            ],
          ),
        ),
      ],
    );
  }

  tags(Product value, BuildContext context) {
    return Row(
      children: [
        Text(
          'Tags:',
          style: TextStyles.bodyFont.copyWith(color: AppColors.primeColor),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .7,
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: value.keywords!
                .map((e) => Card(
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            width: 1,
                            color: AppColors.primeColor,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: TextStyles.bodyFontBold
                                .copyWith(color: AppColors.primeColor),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  detailsHead(ProductController productController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageBox(
              productController.product.value.brand!.logoId!,
              width: 50,
              height: 50,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              productController.product.value.brand!.name!,
              style: TextStyles.body,
            )
          ],
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  wishlistController.addToWishlist(
                      productController.product.value.id,
                      productController.product.value,
                      null,
                      addedFrom);
                },
                icon: Icon(
                  Icons.favorite,
                  color: wishlistController.checkIfProductWishlist(
                          productController.product.value.id)
                      ? AppColors.primeColor
                      : AppColors.grey,
                )),
            const SizedBox(
              width: 5,
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.share,
                  color: AppColors.primeColor,
                ))
          ],
        ),
      ],
    );
  }
}
