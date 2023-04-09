import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/data/product/brand.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/section-card.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child:
          ImageSlider(product.images!, MediaQuery.of(context).size.width * .8),
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
    return Obx(() => productController.product.value.id != null
        ? Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    AppBar(
                      toolbarHeight: 40,
                      backgroundColor: AppColors.primeColor,
                      iconTheme: IconThemeData(color: AppColors.commonBgColor),
                      title: Text(
                        productController
                            .product.value.name!.defaultText!.text!,
                        style: TextStyles.body
                            .copyWith(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .32,
                      child: productPageView(productController.product.value,
                          width, height, context),
                    ),
                    const Divider(),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productController.product.value.name!
                                                  .defaultText!.text ??
                                              '',
                                          style: TextStyles.headingFont
                                              .copyWith(
                                                  color: AppColors.primeColor,
                                                  fontSize: 20),
                                        ),
                                        const SizedBox(height: 4),
                                        productVarientView(
                                            productController
                                                    .product.value.varients ??
                                                [],
                                            productController
                                                .activeIndexVariant.value,
                                            productController),
                                      ],
                                    ),
                                    detailsHead(productController),
                                  ],
                                ),
                                // const SizedBox(height: 5),
                                // soldFrom(productController.product.value),
                                const SizedBox(height: 5),
                                const Divider(),
                                deliveryTo(context),
                                const Divider(),
                                brandTile(
                                    productController.product.value.brand),
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
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "${CodeHelp.euro}${productController.varient.value.price!.actualPrice!.toString()}",
                                  style: TextStyles.headingFont,
                                ),
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
                                          onPressed: () async {
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
                                          onPressed: () async {
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
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size(50, 30),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                alignment:
                                                    Alignment.centerLeft),
                                            onPressed: () async {
                                              stateController.showLoader.value =
                                                  true;
                                              if (stateController
                                                  .isLogin.value) {
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
                                                  snackBarClass.showToast(
                                                      context,
                                                      'Your profile is not active yet');
                                                }
                                              } else {
                                                stateController
                                                    .setCurrentTab(3);
                                                var showToast =
                                                    snackBarClass.showToast(
                                                        context,
                                                        'Please Login to preoceed');
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            },
                                            child: Text("Add to cart",
                                                style: TextStyles.titleFont
                                                    .copyWith(
                                                        color:
                                                            AppColors.white)),
                                          )
                                        ]);
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

  Widget AddressDrawer(context) {
    getAddressList() async {
      var detail = await OfflineDBService.get(OfflineDBService.customerInsight);
      Customer cust = Customer.fromMap(detail as Map<String, dynamic>);
      addressList.value = cust.addresses!.cast<Address>();
    }

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
          children: [
            AppBar(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              backgroundColor: AppColors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(),
                  Text(
                    'Shipping',
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
            ListTile(
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
                    return AddressDrawer(context);
                  },
                );
              },
              leading: Icon(Icons.pin_drop, color: AppColors.black, size: 20),
              title: Text(
                'Ship to Your address, ${locationController.addressData.value.zipCode ?? ' '}',
                style: TextStyles.titleFont,
              ),
            ),
            ListView.builder(
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
                    locationController.pinCode.value = currentAddress.zipCode!;
                    Navigator.pop(context);
                    return {};
                  },
                );
              },
            ),
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
                      leading: Icon(Icons.security,
                          color: AppColors.black, size: 15),
                      title: Text(
                        'Secure Payments',
                        style: TextStyles.headingFont,
                      ),
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
                              style: TextStyles.body
                                  .copyWith(color: AppColors.grey),
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
                      leading: Icon(Icons.reset_tv_rounded,
                          color: AppColors.black, size: 15),
                      title: Text(
                        'Refund promise',
                        style: TextStyles.headingFont,
                      ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You can directly communicate to sbazar to request a refund for any defective ,damaged or misdescried items within 30 days of the del ivery date. The promise applies of all product of sbazar',
                              style: TextStyles.body
                                  .copyWith(color: AppColors.grey),
                              softWrap: true,
                              maxLines: 6,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'This refund promise is in addition to the statutory rights that sellers must offer within your jurisdiction and does not affect your ability to seek redress directly against your ability to seek redress directly againstthe seller at any time. you can view out full return and refund policies in our Terms of Use and Sale',
                              style: TextStyles.body
                                  .copyWith(color: AppColors.grey),
                              softWrap: true,
                              maxLines: 6,
                            )
                          ]),
                    ),
                  ],
                ),
              ),
            ))
      ]),
    );
  }

  deliveryTo(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
                  return AddressDrawer(context);
                },
              );
            },
            leading: Icon(Icons.delivery_dining,
                color: AppColors.primeColor, size: 20),
            trailing:
                Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 15),
            title: Text(
              'Shipping',
              style: TextStyles.headingFont,
            ),
            subtitle: Text(
              'Ship to Your address, ${locationController.addressData.value.zipCode ?? ' '}',
              style: TextStyles.body,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
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
            leading:
                Icon(Icons.lock_outline, color: AppColors.primeColor, size: 20),
            trailing:
                Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 15),
            title: Text(
              'Buyer Protection',
              style: TextStyles.headingFont,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.security_rounded,
                        size: 15,
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      label: Text(
                        'Secure Payments',
                        style: TextStyles.body.copyWith(color: AppColors.grey),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 15,
                      ),
                      label: Text(
                        'Refund promise',
                        style: TextStyles.body.copyWith(color: AppColors.grey),
                      ),
                    ),
                  ],
                ),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.check_circle_outline,
                //     size: 15,
                //   ),
                //   style: TextButton.styleFrom(
                //     padding: EdgeInsets.zero,
                //   ),
                //   label: Text(
                //     'Customer service',
                //     style: TextStyles.body.copyWith(color: AppColors.grey),
                //   ),
                // ),
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
    return Column(
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
                          'Redeem with Scoin',
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
              TableRow(children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Details',
                      style: TextStyles.titleFont,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Html(
                      data: productController
                              .product.value.description!.defaultText!.text ??
                          '',
                    ),
                  ),
                )
              ]),
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
    );
  }

  detailsHead(ProductController productController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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

  brandTile(Brand? brand) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Explore more products from ${brand!.name!} brand',
            style: TextStyles.titleFont.copyWith(fontWeight: FontWeight.w600)),
        ListTile(
          onTap: () {
            Modular.to.pushNamed('/home/brandProduct/${brand.id}');
          },
          leading: ImageBox(
            brand.logoId!,
            width: 30,
            height: 30,
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primeColor),
          title: Text(
            brand.name!,
            style: TextStyles.body,
          ),
        ),
      ],
    );
  }
}
