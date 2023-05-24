import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/data/product/brand.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/section-card.dart';
import 'package:amber_bird/ui/widget/show-more-text-widget.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
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
  RxList<Address> addressList = <Address>[].obs;
  ProductDetailScreen(this.pId, this.refId, this.addedFrom, {Key? key});

  Widget productPageView(
      Product product, double width, double height, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: ImageSlider(
          product.images!, MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .23),
    );
  }

  Widget productVarientView(List<Varient> varientList, activeVariant,
      ProductController productController) {
    return SizedBox(
      height: 30,
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
              height: 20,
              child: Card(
                color: currentVarient.varientCode ==
                        productController.varient.value.varientCode
                    ? AppColors.primeColor
                    : Colors.white,
                margin: const EdgeInsets.all(3),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      '${currentVarient.weight!} ${CodeHelp.formatUnit(currentVarient.unit!)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final ProductController productController =
        Get.put(ProductController(pId ?? ''), tag: pId ?? "");
    return Obx(
      () => (productController.product.value.id != null)
          ? Scaffold(
              // appBar: AppBar(
              //   toolbarHeight: 40,
              //   backgroundColor: AppColors.primeColor,
              //   iconTheme: IconThemeData(color: AppColors.commonBgColor),
              //   leadingWidth: 50,
              //   leading: MaterialButton(
              //     onPressed: () {
              //       try {
              //         if (Modular.to.canPop()) {
              //           Modular.to.pop();
              //         } else {
              //           Modular.to.navigate('../../home/main');
              //         }
              //       } catch (err) {
              //         Modular.to.pushNamed('../../home/main');
              //       }
              //     },
              //     child: const Icon(
              //       Icons.arrow_back_ios,
              //       color: Colors.white,
              //       size: 15,
              //     ),
              //   ),
              //   title: Text(
              //     productController.product.value.name!.defaultText!.text!,
              //     style: TextStyles.body
              //         .copyWith(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverLayoutBuilder(
                        builder: (BuildContext context, constraints) {
                      final scrolled = constraints.scrollOffset >
                          MediaQuery.of(context).size.height * .35;
                      return new SliverAppBar(
                        toolbarHeight: 40,
                        backgroundColor:
                            !scrolled ? Colors.white : AppColors.primeColor,
                        automaticallyImplyLeading: true,
                        pinned: true,
                        iconTheme: IconThemeData(color: AppColors.primeColor),
                        //  floating: false,
                        // backwardsCompatibility: true,
                        excludeHeaderSemantics: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height * .35,
                        stretch: false,
                        leading: IconButton(
                          onPressed: () {
                            appbarScrollController.shrinkappbar.value = false;
                            try {
                              if (Modular.to.canPop()) {
                                Navigator.pop(context);
                                Modular.to.pop();
                              } else {
                                Modular.to.navigate('../../home/main');
                              }
                            } catch (err) {
                              Modular.to.pushNamed('../../home/main');
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                            color: !scrolled ? Colors.black : AppColors.white,
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          collapseMode: CollapseMode.pin,
                          titlePadding: const EdgeInsets.all(0),
                          title: !scrolled
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0)),
                                  padding: const EdgeInsets.all(0),
                                  child: productPageView(
                                      productController.product.value,
                                      width,
                                      height,
                                      context),
                                )
                              : Text(
                                  productController
                                      .product.value.name!.defaultText!.text!,
                                  style: TextStyles.body.copyWith(
                                      color: Colors.white, fontSize: 20),
                                ),
                          background: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SizedBox(),
                          ),
                        ),
                      );
                    })
                  ];
                },
                body: Stack(
                  children: [
                    ScrollWrapper(
                      promptReplacementBuilder: (context, function) =>
                          MaterialButton(
                        onPressed: () => function(),
                        child: const Text(''),
                      ),
                      builder: (context, properties) => SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 45),
                        child: Column(
                          children: [
                            Divider(
                              color: AppColors.lightGrey,
                              height: 8,
                              thickness: 8,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                productController
                                                        .product
                                                        .value
                                                        .name!
                                                        .defaultText!
                                                        .text ??
                                                    '',
                                                style: TextStyles.headingFont
                                                    .copyWith(
                                                        color: AppColors
                                                            .primeColor,
                                                        fontSize: 20),
                                              ),
                                              const SizedBox(height: 4),
                                              productVarientView(
                                                  productController.product
                                                          .value.varients ??
                                                      [],
                                                  productController
                                                      .activeIndexVariant.value,
                                                  productController),
                                            ],
                                          ),
                                        ),
                                        detailsHead(productController,
                                            stateController, context),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(height: 5),
                                  // soldFrom(productController.product.value),
                                  // const SizedBox(height: 5),
                                  productController
                                          .varient.value.msdApplicableProduct!
                                      ? Divider(
                                          color: AppColors.lightGrey,
                                          height: 8,
                                          thickness: 8,
                                        )
                                      : const SizedBox(),
                                  productController
                                          .varient.value.msdApplicableProduct!
                                      ? MsdPrice(context,
                                          productController.varient.value.price)
                                      : const SizedBox(),
                                  Divider(
                                    color: AppColors.lightGrey,
                                    height: 8,
                                    thickness: 8,
                                  ),
                                  deliveryTo(productController, context),
                                  Divider(
                                    color: AppColors.lightGrey,
                                    height: 8,
                                    thickness: 8,
                                  ),
                                  brandTile(
                                      productController.product.value.brand),
                                  Divider(
                                    color: AppColors.lightGrey,
                                    height: 8,
                                    thickness: 8,
                                  ),
                                  productController.recommendedProd.length > 0
                                      ? recommendedProd(productController)
                                      : const SizedBox(),
                                  productController.recommendedProd.length > 0
                                      ? Divider(
                                          color: AppColors.lightGrey,
                                          height: 8,
                                          thickness: 8,
                                        )
                                      : const SizedBox(),
                                  specification(productController),
                                  // tags(productController.product.value, context),
                                  // Divider(
                                  //   color: AppColors.lightGrey,
                                  //   height: 8,
                                  //   thickness: 8,
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8.0, right: 8),
                                  //   child: Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text(
                                  //           'Details',
                                  //           style: TextStyles.headingFont,
                                  //         ),
                                  //         ShowMoreWidget(
                                  //           text: productController
                                  //                   .product
                                  //                   .value
                                  //                   .description!
                                  //                   .defaultText!
                                  //                   .text ??
                                  //               '',
                                  //         ),
                                  //       ]),
                                  // ),
                                  Divider(
                                    color: AppColors.lightGrey,
                                    height: 8,
                                    thickness: 8,
                                  ),
                                  desclaimer(context)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primeColor,
                              textStyle: TextStyles.body
                                  .copyWith(color: AppColors.white)),
                          onPressed: productController
                                      .product.value.varients![0].currentStock >
                                  0
                              ? () {}
                              : () {},
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "${productController.varient.value.price!.actualPrice!.toString()}${CodeHelp.euro}",
                                      style: TextStyles.headingFont,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () {
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
                                      "varient": productController.varient.value
                                          .toMap(),
                                      "category": productController
                                          .product.value.category!
                                          .toMap(),
                                      "countryCode": productController
                                          .product.value.countryCode,
                                      "id": productController.product.value.id
                                    });
                                    return cartController.checkProductInCart(
                                            '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                            addedFrom)
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  stateController
                                                      .showLoader.value = true;
                                                  if (stateController
                                                      .isLogin.value) {
                                                    await cartController.addToCart(
                                                        '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                        addedFrom!,
                                                        -1,
                                                        productController
                                                            .varient
                                                            .value
                                                            .price!,
                                                        summary,
                                                        null,
                                                        null,
                                                        null,
                                                        productController
                                                            .varient.value);
                                                    productController
                                                        .getofferShipping();
                                                  } else {
                                                    stateController.showLoader
                                                        .value = false;
                                                    stateController
                                                        .setCurrentTab(3);

                                                    snackBarClass.showToast(
                                                        context,
                                                        'Please login to proceed');
                                                  }
                                                  stateController
                                                      .showLoader.value = false;
                                                  // cController.addToCart(p, refId!, addedFrom!, -1);
                                                },
                                                icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                    size: 25,
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  cartController
                                                      .getCurrentQuantity(
                                                          '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                          '')
                                                      .toString(),
                                                  style: TextStyles.titleFont
                                                      .copyWith(
                                                          color:
                                                              AppColors.white)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  stateController
                                                      .showLoader.value = true;
                                                  if (stateController
                                                      .isLogin.value) {
                                                    await cartController.addToCart(
                                                        '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                        addedFrom!,
                                                        1,
                                                        productController
                                                            .varient
                                                            .value
                                                            .price!,
                                                        summary,
                                                        null,
                                                        null,
                                                        null,
                                                        productController
                                                            .varient.value);
                                                    productController
                                                        .getofferShipping();
                                                  } else {
                                                    stateController
                                                        .setCurrentTab(3);
                                                    snackBarClass.showToast(
                                                        context,
                                                        'Please Login to preoceed');
                                                  }
                                                  stateController
                                                      .showLoader.value = false;
                                                  // cController.addToCart(p, refId!, addedFrom!, 1);
                                                },
                                                icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    size: 25,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.only(
                                                        left: 3, right: 10),
                                                    minimumSize: Size(50, 30),
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    alignment:
                                                        Alignment.centerLeft),
                                                onPressed: () async {
                                                  stateController
                                                      .showLoader.value = true;
                                                  if (stateController
                                                      .isLogin.value) {
                                                    bool isCheckedActivate =
                                                        await stateController
                                                            .getUserIsActive();
                                                    if (isCheckedActivate) {
                                                      await cartController
                                                          .addToCart(
                                                              '${productController.product.value.id!}@${productController.varient.value.varientCode}',
                                                              addedFrom!,
                                                              1,
                                                              productController
                                                                  .varient
                                                                  .value
                                                                  .price!,
                                                              summary,
                                                              null,
                                                              null,
                                                              null,
                                                              productController
                                                                  .varient
                                                                  .value);
                                                      productController
                                                          .getofferShipping();
                                                    } else {
                                                      // Navigator.of(context).pop();
                                                      // ignore: use_build_context_synchronously
                                                      snackBarClass.showToast(
                                                          context,
                                                          'Your profile is not active yet');
                                                    }
                                                  } else {
                                                    stateController
                                                        .setCurrentTab(3);

                                                    snackBarClass.showToast(
                                                        context,
                                                        'Please Login to preoceed');
                                                  }
                                                  stateController
                                                      .showLoader.value = false;
                                                },
                                                child: Text(
                                                  "Add to cart",
                                                  style: TextStyles.titleFont
                                                      .copyWith(
                                                          color:
                                                              AppColors.white),
                                                ),
                                              )
                                            ],
                                          );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : const Center(
              child: Text("Loading"),
            ),
    );
  }

  Widget desclaimer(context) {
    return Container(
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Disclaimer',
            style: TextStyles.headingFont,
          ),
          RichText(
            text: TextSpan(
              style: TextStyles.body,
              children: <TextSpan>[
                TextSpan(
                  text:
                      'Product description on SBazar website and app are for informational purposes only ',
                  style: TextStyles.body.copyWith(color: AppColors.DarkGrey),
                ),
                TextSpan(
                    text: 'check our disclaimer',
                    style: TextStyles.body.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: false,
                            builder: (context) {
                              return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  child: DisclaimerWidgetDrawer(context));
                            });
                      }),
              ],
            ),
          ),
          // Text(
          //   'Product description on SBazar website and app are for informational purposes only',
          //   style: TextStyles.body,
          // ),
          // TextButton(
          //   onPressed: () async {
          //     showModalBottomSheet(
          //         context: context,
          //         isScrollControlled: true,
          //         enableDrag: false,
          //         builder: (context) {
          //           return SizedBox(
          //               height: MediaQuery.of(context).size.height * .7,
          //               child: DisclaimerWidgetDrawer(context));
          //         });
          //   },
          //   style: ButtonStyle(
          //       ),
          //   child: Text(
          //     'See our disclaimer',
          //     style: TextStyles.headingFont.copyWith(color: AppColors.primeColor),
          //   ),
          // ),
        ]),
      ),
    );
  }

  Widget DisclaimerWidgetDrawer(context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      // constraints:
      //     BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            backgroundColor: AppColors.white,
            leadingWidth: 50,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(),
                Text(
                  'Disclaimer',
                  style: TextStyles.headingFont,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            leading: const SizedBox(),
          ),
          Divider(
            color: AppColors.lightGrey,
            height: 1,
            thickness: 1,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text(
                'Poduct description on Sbazar! website and app are informational purpose only, Sbazar does not warrant or represent, or assume any responsibility for, the accuracy of any nutritional,allergn or proposition 65 warning information listed in the product desription',
                style: TextStyles.body,
              )),
          Divider(
            color: AppColors.lightGrey,
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget recommendedProd(ProductController productController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Recommended Product',
                    style: TextStyles.headingFont,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productController.recommendedProd.length,
                  itemBuilder: (_, index) {
                    ProductSummary product =
                        productController.recommendedProd[index];
                    return SizedBox(
                      width: 150,
                      child: Stack(
                        children: [
                          ProductCard(
                              fixedHeight: true,
                              product,
                              product.id,
                              'RECOMMENDED', // currentdealName.toString(),
                              product.varient!.price,
                              RuleConfig(),
                              Constraint()),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget AddressDrawer(productController, context) {
    getAddressList() async {
      var detail = await OfflineDBService.get(OfflineDBService.customerInsight);
      Customer cust = Customer.fromMap(detail as Map<String, dynamic>);
      addressList.value = cust.addresses!.cast<Address>();
    }

    productController.getofferShipping();

    getAddressList();

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
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              elevation: 1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              backgroundColor: AppColors.white,
              leadingWidth: 50,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(),
                  Text(
                    'Shipping Policy',
                    style: TextStyles.headingFont,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              leading: ImageBox(
                stateController.membershipIcon.value,
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              onTap: () {},
              dense: true,
              minLeadingWidth: 20,
              horizontalTitleGap: 10,
              trailing: SizedBox(
                width: 100,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(locationController.addressData.value.country ?? ' '),
                  Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 15)
                ]),
              ),
              leading:
                  Icon(Icons.pin_drop_sharp, color: AppColors.black, size: 20),
              title: Text(
                'Ship to',
                style: TextStyles.headingFont,
              ),
            ),
            Divider(
              color: AppColors.lightGrey,
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child:
                  (productController.offerShipping.value['amountRequired'] < 0)
                      ? Text(
                          'Free shipping ',
                          style: TextStyles.headingFont,
                        )
                      : Text(
                          'Add ${Helper.getFormattedNumber(productController.offerShipping.value['amountRequired'] as double)}${CodeHelp.euro}, for ${productController.offerShipping.value['offeredShipping'] == 0 ? 'free' : productController.offerShipping.value['offeredShipping'].toString() + CodeHelp.euro} shipping',
                          //${productController.offerShipping.value['offeredShipping']}${CodeHelp.euro} Shipping cost or buy more of ${CodeHelp.euro}${productController.offerShipping.value['amountRequired']}',
                          style: TextStyles.body,
                        ),
            ),
            Divider(
              color: AppColors.lightGrey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              child: SingleChildScrollView(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addressList.length,
                  itemBuilder: (_, index) {
                    var currentAddress = addressList[index];
                    return addressCard(
                      context,
                      locationController,
                      index,
                      currentAddress,
                      () {
                        locationController.addressData.value = currentAddress;
                        locationController.pinCode.value =
                            currentAddress.zipCode!;
                        Navigator.pop(context);
                        return {};
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget BuyerProtectionDrawer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .60,
      child: Column(children: [
        AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          backgroundColor: AppColors.white,
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(),
              Text(
                'Buyer Protection',
                style: TextStyles.headingFont,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          leading: SizedBox(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .52,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {},
                    leading:
                        Icon(Icons.security, color: AppColors.black, size: 15),
                    title: Text(
                      'Secure Payments',
                      style: TextStyles.headingFont,
                    ),
                    dense: true,
                    minLeadingWidth: 20,
                    horizontalTitleGap: 10,
                    // contentPadding: const EdgeInsets.all(2),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Accepted Payment methods',
                            style: TextStyles.titleFont
                                .copyWith(color: AppColors.grey),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Image.asset(
                            'assets/payment-methods.png',
                            width: MediaQuery.of(context).size.width * .8,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'For information about how sbazar uses your personal data view iur privacy policy',
                            style:
                                TextStyles.body.copyWith(color: AppColors.grey),
                            softWrap: true,
                            maxLines: 3,
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.headset_mic,
                        color: AppColors.black, size: 15),
                    title: Text(
                      'Customer Service',
                      style: TextStyles.headingFont,
                    ),
                    dense: true,
                    minLeadingWidth: 20,
                    horizontalTitleGap: 10,
                    // contentPadding: const EdgeInsets.all(2),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get in touch with our customer service team if you have any queries or concerns',
                            style:
                                TextStyles.body.copyWith(color: AppColors.grey),
                            softWrap: true,
                            maxLines: 6,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  MsdPrice(context, price) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        itemCount: stateController.membershipList.length,
        itemBuilder: (_, index) {
          var currentKey =
              stateController.membershipList.value.keys.elementAt(index);
          var currenMemberInfo =
              stateController.membershipList.value[currentKey]!;

          return currenMemberInfo.id != memberShipType.No_Membership.name
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    children: [
                      ImageBox(
                        currenMemberInfo.imageId!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        Helper.getFormattedNumber(Helper.getMsdAmount(
                                price: price!, userType: currenMemberInfo.id!))
                            .toString(),
                        style: TextStyles.headingFont,
                      ),
                    ],
                  ),
                )
              : SizedBox();
        },
      ),
    );
    //     Row(
    //       children: [
    //         ImageBox(
    //           stateController.membershipIcon.value,
    //           height: 20,
    //           width: 20,
    //           fit: BoxFit.contain,
    //         ),
    //         Text(
    //           Helper.getFormattedNumber(Helper.getMsdAmount(
    //                   price: price!, userType: stateController.userType.value))
    //               .toString(),
    //           style: TextStyles.headingFont,
    //         ),
    //       ],
    //     ),
    //     Row(
    //       children: [
    //         ImageBox(
    //           stateController.membershipIcon.value,
    //           height: 20,
    //           width: 20,
    //           fit: BoxFit.contain,
    //         ),
    //         Text(
    //           Helper.getFormattedNumber(Helper.getMsdAmount(
    //                   price: price!, userType: stateController.userType.value))
    //               .toString(),
    //           style: TextStyles.headingFont,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  deliveryTo(productController, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: ListTile(
            onTap: () {
              showModalBottomSheet<void>(
                // context and builder are
                // required properties in this widget
                context: context,
                useRootNavigator: true,
                isDismissible: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                elevation: 3,
                builder: (context) {
                  return AddressDrawer(productController, context);
                },
              );
            },
            dense: true,
            minLeadingWidth: 20,
            horizontalTitleGap: 10,
            contentPadding: const EdgeInsets.all(2),
            leading: Icon(Icons.delivery_dining,
                color: AppColors.primeColor, size: 20),
            trailing:
                Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 15),
            title: Obx(() =>
                (productController.offerShipping.value['amountRequired'] <= 0)
                    ? Text(
                        'Free shipping ',
                        style: TextStyles.headingFont,
                      )
                    : Text(
                        'Add ${Helper.getFormattedNumber(productController.offerShipping.value['amountRequired'] as double)}${CodeHelp.euro}, for ${(productController.offerShipping.value['offeredShipping'] as double) == 0 ? 'free' : productController.offerShipping.value['offeredShipping'].toString() + CodeHelp.euro} shipping',
                        style: TextStyles.headingFont,
                      )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${Helper.getShipping()}${CodeHelp.euro} Standard Shipping',
                style: TextStyles.body,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: ListTile(
            onTap: () {
              showModalBottomSheet<void>(
                // context and builder are
                // required properties in this widget
                context: context,
                useRootNavigator: true,
                isDismissible: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                elevation: 3,
                builder: (context) {
                  return BuyerProtectionDrawer(context);
                },
              );
            },
            dense: true,
            minLeadingWidth: 20,
            horizontalTitleGap: 10,
            contentPadding: const EdgeInsets.all(2),
            leading:
                Icon(Icons.lock_outline, color: AppColors.primeColor, size: 20),
            trailing:
                Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 15),
            title: Text(
              'Buyer Protection',
              style: TextStyles.headingFont,
            ),
            subtitle: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.accessibility,
                        size: 15,
                      ),
                      Text(
                        'Customer Service',
                        style: TextStyles.body.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.security_rounded,
                        size: 15,
                      ),
                      Text(
                        'Secure Payments',
                        style: TextStyles.body.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
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
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
              Text(
                '${value.category!.parent!.name!.defaultText!.text}',
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Specification",
            style: TextStyles.titleFont.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: const {
                0: FractionColumnWidth(.30),
              },
              children: [
                TableRow(children: [
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Category',
                          style: TextStyles.titleFont,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Weight',
                          style: TextStyles.titleFont,
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
                ]),
                if (productController.varient.value.scoinPurchaseEnable!) ...[
                  TableRow(children: [
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Redeem with S-COINS',
                            style: TextStyles.titleFont,
                          ),
                        )),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: PriceTag(
                          productController.varient.value.price!.offerPrice!
                              .toString(),
                          productController.varient.value.price!.actualPrice!
                              .toString(),
                          scoin: Helper.getMemberCoinValue(
                              productController.varient.value.price!,
                              stateController.userType.value),
                        ),
                      ),
                    )
                  ])
                ],
                if (productController.product.value.tags!.length > 0) ...[
                  TableRow(
                    children: [
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Special Tags',
                              style: TextStyles.titleFont,
                            ),
                          )),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productController
                                  .product.value.keywords!.length,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                var currentTag = productController
                                    .product.value.keywords![index];
                                return SizedBox(
                                  height: 20,
                                  child: Card(
                                    margin: const EdgeInsets.all(3),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: GestureDetector(
                                          onTap: () {
                                            Modular.to.pushNamed(
                                                '/widget/tag-product/${currentTag}');
                                          },
                                          child: Text('${currentTag}',
                                              style: TextStyles.body.copyWith(
                                                  color: AppColors.primeColor)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
                TableRow(
                  children: [
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Nutrition',
                            style: TextStyles.titleFont,
                          ),
                        )),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Html(
                            data: productController.product.value
                                            .nutritionDetail!.defaultText !=
                                        null &&
                                    productController
                                            .product
                                            .value
                                            .nutritionDetail!
                                            .defaultText!
                                            .text !=
                                        null
                                ? productController.product.value
                                        .nutritionDetail!.defaultText!.text ??
                                    ''
                                : productController
                                        .product
                                        .value
                                        .nutritionDetail!
                                        .languageTexts![0]
                                        .text ??
                                    '',
                            style: {
                              "body": Style(
                                  fontSize: FontSize(FontSizes.body),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: Fonts.body),
                            }),
                      ),
                    )
                  ],
                ),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        'Details',
                        style: TextStyles.titleFont,
                      ),
                    ),
                  ),
                  TableCell(child: SizedBox())
                ]),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(0),
              child: ShowMoreWidget(
                  text: productController
                          .product.value.description!.defaultText!.text ??
                      '')),
        ],
      ),
    );
  }

  tags(Product value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            'Tags:',
            style: TextStyles.bodyFont.copyWith(color: AppColors.primeColor),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .7,
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: value.keywords!
                  .map((e) => Card(
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
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
      ),
    );
  }

  detailsHead(ProductController productController, Controller controller,
      BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    controller.showLoader.value = true;
                    if (stateController.isLogin.value) {
                      await wishlistController.addToWishlist(
                          productController.product.value.id,
                          productController.product.value,
                          null,
                          addedFrom);
                    } else {
                      stateController.setCurrentTab(3);

                      snackBarClass.showToast(
                          context, 'Please login to proceed');
                    }
                    controller.showLoader.value = false;
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
                  onPressed: () async {
                    // await productController
                    CodeHelp.shareWithOther(
                        'Buy this Product now, ${productController.shortLink.value}',
                        'Share now');
                  },
                  icon: Icon(
                    CupertinoIcons.share,
                    color: AppColors.primeColor,
                  ))
            ],
          ),
        ],
      ),
    );
  }

  brandTile(Brand? brand) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Explore more products from ${brand!.name!} brand',
              style:
                  TextStyles.titleFont.copyWith(fontWeight: FontWeight.w600)),
          ListTile(
            onTap: () {
              Modular.to.pushNamed('/widget/brandProduct/${brand.id}');
            },
            leading: ImageBox(
              brand.logoId!,
              width: 30,
              height: 30,
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, color: AppColors.primeColor),
            title: Text(
              brand.name!,
              style: TextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
