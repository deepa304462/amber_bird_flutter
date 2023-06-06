import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/price/price.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/add-to-cart-button.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/like-button.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/deal-row.dart';

class PreCheckoutWidget extends StatelessWidget {
  CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  RxBool checkoutClicked = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController ipController = TextEditingController();
  RxList<SliverList> checkoutLists = <SliverList>[].obs;
  Rx<Varient> activeVariant = Varient().obs;
  final WishlistController wishlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        leading: MaterialButton(
          onPressed: () {
            if (Modular.to.canPop()) {
              Modular.to.pop();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Modular.to.navigate('../../home/main');
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 15,
          ),
        ),
        title: Column(
          children: [
            Text(
              'Cart',
              style: TextStyles.headingFont.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Colors.grey))),
        child: Obx(
          () => (cartController.cartProducts.isNotEmpty ||
                      cartController.cartProductsScoins.isNotEmpty ||
                      cartController.msdProducts.isNotEmpty) &&
                  cartController.calculatedPayment.value.totalAmount != null &&
                  cartController.calculatedPayment.value.totalAmount as double >
                      0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL PRICE',
                            style: TextStyles.body,
                          ),
                          Text(
                            '${(cartController.calculatedPayment.value.totalAmount != null ? cartController.calculatedPayment.value.totalAmount as double : 0).toStringAsFixed(2)}${CodeHelp.euro}',
                            style: TextStyles.headingFont,
                          ),
                        ],
                      ),
                      MaterialButton(
                        color: Colors.green,
                        visualDensity: const VisualDensity(horizontal: 4),
                        onPressed: () async {
                          Modular.to.navigate('/widget/checkout');
                        },
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          isLoading.value ? 'Loading' : 'Continue',
                          style: TextStyles.bodyFontBold
                              .copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ))
              : const SizedBox(),
        ),
      ),
      body: Stack(children: [
        IgnorePointer(
          ignoring: isLoading.value,
          child: Obx(
            () {
              checkoutLists.clear();
              checkoutLists.add(
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        productCheckoutListWidget(context, cartController),
                    childCount: 1,
                  ),
                ),
              );
              checkoutLists.add(
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        scoinCheckoutPRoductList(context, cartController),
                    childCount: 1,
                  ),
                ),
              );
              checkoutLists.add(
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        msdCheckoutPRoductList(context, cartController),
                    childCount: 1,
                  ),
                ),
              );

              checkoutLists.add(
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => Padding(
                        padding: EdgeInsets.all(10),
                        child: DealRow(dealName.WEEKLY_DEAL.name)),
                    childCount: 1,
                  ),
                ),
              );
              checkoutLists.add(
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        DealRow(dealName.FLASH.name),
                    childCount: 1,
                  ),
                ),
              );

              cartController.clearCheckout();

              return (cartController.cartProducts.isNotEmpty ||
                      cartController.cartProductsScoins.isNotEmpty)
                  ? CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: checkoutLists,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Your Cart is Empty',
                              style: TextStyles.body,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primeColor,
                                  textStyle: TextStyles.body
                                      .copyWith(color: AppColors.white)),
                              onPressed: () {
                                Modular.to.navigate('../home/main');
                              },
                              child: Text(
                                'Add Products',
                                style: TextStyles.headingFont
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () =>
                  isLoading.value ? const LoadingWithLogo() : const SizedBox(),
            ),
          ),
        )
      ]),
    );
  }

  msdCheckoutPRoductList(context, cartController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: cartController.msdProducts.length,
      itemBuilder: (_, index) {
        var currentKey = cartController.msdProducts.value.keys.elementAt(index);
        var currentProduct = cartController.msdProducts.value[currentKey]!;
        var minOrder = (currentProduct.constraint != null &&
                currentProduct.constraint.minimumOrder != null)
            ? currentProduct.constraint!.minimumOrder
            : 1;
        var currentMemberPrice = Helper.getMsdAmount(
            price: currentProduct.price!,
            userType: stateController.userType.value);
        return Column(
          children: [
            currentProduct.products!.isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Divider()),
                          FitText(
                            '${currentProduct.name}',
                            style: TextStyles.headingFont
                                .copyWith(color: AppColors.primeColor),
                          ),
                          const Expanded(child: Divider()),
                        ]),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .73,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: currentProduct.products!.length,
                                itemBuilder: (_, pIndex) {
                                  var currentInnerProduct =
                                      currentProduct.products![pIndex];
                                  return ListTile(
                                    dense: false,
                                    visualDensity:
                                        const VisualDensity(vertical: 3),
                                    leading: ImageBox(
                                      '${currentInnerProduct.images![0]}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                    title: FitText(
                                      currentInnerProduct
                                          .name!.defaultText!.text!,
                                      style: TextStyles.headingFont,
                                      align: TextAlign.start,
                                    ),
                                    subtitle: Text(
                                      '${currentInnerProduct.varient!.weight.toString()} ${CodeHelp.formatUnit(currentInnerProduct!.varient!.unit)}',
                                      style: TextStyles.body,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageBox(
                                    stateController.membershipIcon.value,
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                                  Text(
                                    '${Helper.getFormattedNumber(currentMemberPrice * currentProduct.count).toString()}${CodeHelp.euro}',
                                    style: TextStyles.headingFont,
                                  ),
                                  Card(
                                    color: AppColors.primeColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                          onPressed: () async {
                                            isLoading.value = true;
                                            if (stateController.isLogin.value) {
                                              var valid = false;
                                              var msg = 'Something went wrong!';

                                              if (currentProduct.ruleConfig !=
                                                      null ||
                                                  currentProduct.constraint !=
                                                      null) {
                                                dynamic data = await Helper
                                                    .checkProductValidtoAddinCart(
                                                        currentProduct
                                                            .ruleConfig,
                                                        currentProduct
                                                            .constraint,
                                                        currentProduct
                                                                .ref!.id ??
                                                            '',
                                                        currentProduct
                                                                .ref!.id ??
                                                            '');
                                                valid = !data['error'];
                                                msg = data['msg'];
                                              }
                                              if (valid) {
                                                await cartController.addToCartMSD(
                                                    '${currentProduct.ref!.id}',
                                                    currentProduct.ref!.name!,
                                                    minOrder,
                                                    currentProduct.price,
                                                    null,
                                                    currentProduct.products,
                                                    currentProduct.ruleConfig,
                                                    currentProduct.constraint,
                                                    null,
                                                    mutliProductName:
                                                        currentProduct.name ??
                                                            "");
                                              } else {
                                                var showToast = snackBarClass
                                                    .showToast(context, msg);
                                              }
                                            }
                                            isLoading.value = false;
                                          },
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.white,
                                            size: FontSizes.title,
                                          ),
                                        ),
                                        Text(
                                            cartController
                                                .getCurrentQuantity(
                                                    '${currentProduct.ref!.id}',
                                                    'MSD')
                                                .toString(),
                                            style: TextStyles.headingFont
                                                .copyWith(color: Colors.white)),
                                        IconButton(
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                          onPressed: () async {
                                            isLoading.value = true;
                                            if (stateController.isLogin.value) {
                                              var valid = false;
                                              var msg = 'Something went wrong!';

                                              if (currentProduct.ruleConfig !=
                                                      null ||
                                                  currentProduct.constraint !=
                                                      null) {
                                                dynamic data = await Helper
                                                    .checkProductValidtoAddinCart(
                                                        currentProduct
                                                            .ruleConfig,
                                                        currentProduct
                                                            .constraint,
                                                        currentProduct
                                                                .ref!.id ??
                                                            '',
                                                        currentProduct
                                                                .ref!.id ??
                                                            '');
                                                valid = !data['error'];
                                                msg = data['msg'];
                                              }
                                              if (valid) {
                                                await cartController.addToCartMSD(
                                                    '${currentProduct.ref!.id}',
                                                    currentProduct.ref!.name!,
                                                    minOrder,
                                                    currentProduct.price,
                                                    null,
                                                    currentProduct.products,
                                                    currentProduct.ruleConfig,
                                                    currentProduct.constraint,
                                                    null,
                                                    mutliProductName:
                                                        currentProduct.name ??
                                                            '');
                                              } else {
                                                var showToast = snackBarClass
                                                    .showToast(context, msg);
                                              }
                                            }
                                            isLoading.value = false;
                                          },
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.white,
                                            size: FontSizes.title,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            cartCheckoutButtons(
                                context, cartController, currentKey),
                            MaterialButton(
                                onPressed: () async {
                                  isLoading.value = true;
                                  await cartController.removeProduct(
                                      currentKey, 'MSD');
                                  isLoading.value = false;
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Remove',
                                      style: TextStyles.body.copyWith(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          dense: false,
                          visualDensity: const VisualDensity(vertical: 3),
                          leading: ImageBox(
                            currentProduct.product!.images![0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          title: FitText(
                            currentProduct.product!.name!.defaultText!.text!,
                            style: TextStyles.headingFont,
                            align: TextAlign.start,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '${currentProduct.product!.varient!.weight.toString()} ${CodeHelp.formatUnit(currentProduct.product!.varient!.unit)}/ ',
                                style: TextStyles.body,
                              ),
                              ImageBox(
                                stateController.membershipIcon.value,
                                height: 20,
                                width: 20,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                  '${Helper.getFormattedNumber(currentMemberPrice).toString()}${CodeHelp.euro} ',
                                  style: TextStyles.body),
                            ],
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 60,
                                child: Row(
                                  children: [
                                    ImageBox(
                                      stateController.membershipIcon.value,
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      '${Helper.getFormattedNumber(currentMemberPrice * currentProduct.count).toString()}${CodeHelp.euro}',
                                      style: TextStyles.headingFont,
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                color: AppColors.primeColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      onPressed: () async {
                                        isLoading.value = true;
                                        if (stateController.isLogin.value) {
                                          await cartController.addToCartMSD(
                                            '${currentProduct.ref!.id}',
                                            currentProduct.ref!.name!,
                                            -minOrder,
                                            currentProduct.price,
                                            currentProduct.product,
                                            null,
                                            currentProduct.ruleConfig,
                                            currentProduct.constraint,
                                            currentProduct.product.varient,
                                          );
                                        } else {
                                          stateController.setCurrentTab(3);

                                          snackBarClass.showToast(context,
                                              'Please Login to preoceed');
                                        }
                                        isLoading.value = false;
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.white,
                                        size: FontSizes.title,
                                      ),
                                    ),
                                    Text(
                                      cartController
                                          .getCurrentQuantity(
                                              '${currentProduct.ref!.id}',
                                              'MSD')
                                          .toString(),
                                      style: TextStyles.headingFont
                                          .copyWith(color: Colors.white),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                      onPressed: () async {
                                        isLoading.value = true;
                                        if (stateController.isLogin.value) {
                                          var valid = false;
                                          var msg = 'Something went wrong!';

                                          if (currentProduct.ruleConfig !=
                                                  null ||
                                              currentProduct.constraint !=
                                                  null) {
                                            dynamic data = await Helper
                                                .checkProductValidtoAddinCart(
                                                    currentProduct.ruleConfig,
                                                    currentProduct.constraint,
                                                    currentProduct.ref!.id ??
                                                        "",
                                                    currentProduct.ref!.id ??
                                                        '');
                                            valid = !data['error'];
                                            msg = data['msg'];
                                          }
                                          if (valid) {
                                            await cartController.addToCartMSD(
                                                '${currentProduct.ref!.id}',
                                                currentProduct.ref!.name!,
                                                minOrder,
                                                currentProduct.price,
                                                currentProduct.product,
                                                null,
                                                currentProduct.ruleConfig,
                                                currentProduct.constraint,
                                                currentProduct.product.varient);
                                          } else {
                                            snackBarClass.showToast(
                                                context, msg);
                                          }
                                        }
                                        isLoading.value = false;
                                      },
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.white,
                                        size: FontSizes.title,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            cartCheckoutButtons(
                                context, cartController, currentKey),
                            MaterialButton(
                              onPressed: () async {
                                isLoading.value = true;
                                await cartController.removeProduct(
                                    currentKey, 'MSD');
                                isLoading.value = false;
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Remove',
                                    style: TextStyles.body.copyWith(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
            Obx(() => checkoutClicked.value &&
                    !cartController.checktOrderRefAvailable(
                        cartController.cartProducts.value[currentKey]!.ref)
                ? recpmmondedCheckoutProduct(
                    context, cartController, currentKey)
                : const SizedBox())
          ],
        );
      },
    );
  }

  scoinCheckoutPRoductList(context, cartController) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartController.cartProductsScoins.length,
      itemBuilder: (_, index) {
        var currentKey =
            cartController.cartProductsScoins.value.keys.elementAt(index);
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: false,
                visualDensity: const VisualDensity(vertical: 3),
                leading: ImageBox(
                  cartController.cartProductsScoins.value[currentKey]!.product!
                      .images![0],
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                title: FitText(
                  cartController.cartProductsScoins.value[currentKey]!.product!
                      .name!.defaultText!.text!,
                  style: TextStyles.headingFont,
                  align: TextAlign.start,
                ),
                subtitle: Row(
                  children: [
                    Text(
                      '${cartController.cartProductsScoins.value[currentKey]!.product!.varient!.weight.toString()} ${CodeHelp.formatUnit(cartController.cartProductsScoins.value[currentKey]!.product!.varient!.unit)}',
                      style: TextStyles.body,
                    ),
                    Text(
                        '/${Helper.getMemberCoinValue(cartController.cartProductsScoins.value[currentKey]!.product!.varient!.price!, stateController.userType.value)} ',
                        style: TextStyles.body),
                  ],
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Helper.getFormattedNumber(Helper.getMemberCoinValue(
                                        cartController
                                            .cartProductsScoins[currentKey]!
                                            .price!,
                                        stateController.userType.value) *
                                    cartController
                                        .cartProductsScoins[currentKey]!.count)
                                .toString(),
                            style: TextStyles.headingFont,
                          ),
                          Lottie.asset('assets/coin.json',
                              height: 25, fit: BoxFit.fill, repeat: true),
                        ],
                      ),
                    ),
                    Card(
                      color: AppColors.primeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              isLoading.value = true;
                              if (stateController.isLogin.value) {
                                await cartController.addToCartScoins(
                                    cartController
                                        .cartProductsScoins[currentKey].ref!.id,
                                    'SCOIN',
                                    -1,
                                    cartController
                                        .cartProductsScoins[currentKey].price,
                                    cartController
                                        .cartProductsScoins[currentKey].product,
                                    null,
                                    RuleConfig(),
                                    Constraint(),
                                    cartController
                                        .cartProductsScoins[currentKey]
                                        .product
                                        .varient);
                              } else {
                                stateController.setCurrentTab(4);
                                var showToast = snackBarClass.showToast(
                                    context, 'Please Login to preoceed');
                              }
                              isLoading.value = false;
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          Text(
                              cartController
                                  .getCurrentQuantity(
                                      '${cartController.cartProductsScoins[currentKey].ref!.id}',
                                      'SCOIN')
                                  .toString(),
                              style: TextStyles.headingFont
                                  .copyWith(color: Colors.white)),
                          IconButton(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              isLoading.value = true;
                              if (stateController.isLogin.value) {
                                await cartController.addToCartScoins(
                                    cartController
                                        .cartProductsScoins[currentKey].ref!.id,
                                    'SCOIN',
                                    1,
                                    cartController
                                        .cartProductsScoins[currentKey].price,
                                    cartController
                                        .cartProductsScoins[currentKey].product,
                                    null,
                                    RuleConfig(),
                                    Constraint(),
                                    cartController
                                        .cartProductsScoins[currentKey]
                                        .product
                                        .varient);
                              } else {
                                snackBarClass.showToast(
                                    context, 'Please Login');
                              }

                              isLoading.value = false;
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: FontSizes.title,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  isLoading.value = true;
                  await cartController.removeProduct(currentKey, 'SCOIN');
                  isLoading.value = false;
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete,
                      size: 16,
                      color: Colors.grey,
                    ),
                    Text(
                      'Remove',
                      style: TextStyles.body.copyWith(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  checkoutProductCard(
      product, refId, addedFrom, dealPrice, ruleConfig, constraint, context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(2),
      child: Container(
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Column(
                children: [
                  product.images!.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            if (addedFrom == 'BRAND') {
                              Modular.to.pushNamed('../product/${product.id}');
                            } else {
                              Modular.to
                                  .pushNamed('/widget/product/${product.id}');
                            }
                          },
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: ImageBox(product.images == null ||
                                    product.images!.length == 0
                                ? product.category!.logoId
                                : product.images![0] ??
                                    product.category!.logoId),
                          ),
                        )
                      : const SizedBox(
                          child: Text('Empty Image'),
                        ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${product.name!.defaultText!.text ?? ''} ',
                            overflow: true
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                            style: TextStyles.body),
                        addedFrom == 'MULTIPRODUCT'
                            ? Text(
                                '${product.defaultPurchaseCount.toString()} * ${product.varient.price!.offerPrice!}',
                                style: TextStyles.bodySm)
                            : const SizedBox(),
                        Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: [
                            product.varients!.length == 0
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        product.varient!.weight!
                                            .toStringAsFixed(0),
                                        style: TextStyles.body,
                                      ),
                                      Text(
                                        ' ${CodeHelp.formatUnit(product.varient!.unit)}',
                                        style: TextStyles.body,
                                      )
                                    ],
                                  )
                                : (product.varients!.length == 1 ||
                                        addedFrom == 'TAGS_PRODUCT' ||
                                        addedFrom == 'DEAL' ||
                                        addedFrom == 'MULTIPRODUCT')
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            product.varients![0].weight!
                                                .toStringAsFixed(0),
                                            style: TextStyles.body,
                                          ),
                                          Text(
                                            ' ${CodeHelp.formatUnit(product.varients![0].unit)}',
                                            style: TextStyles.body,
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                            Text(
                              "${product.varient.price!.actualPrice!.toString()} ${CodeHelp.euro}",
                              style: TextStyles.headingFont,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: LikeButton(
                        isLiked: wishlistController
                            .checkIfProductWishlist(product.id),
                        onPressed: () async {
                          stateController.showLoader.value = true;
                          await wishlistController.addToWishlist(
                              product.id, product, null, addedFrom);
                          stateController.showLoader.value = false;
                        },
                      ),
                    );
                  }),
                ],
              ),
              Obx(() {
                return Positioned(
                  right: true ? 10 : 20,
                  top: 65,
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.bounceIn,
                    switchOutCurve: Curves.easeOut,
                    duration: const Duration(milliseconds: 200),
                    child: AddToCartButtons(
                      hideAdd: cartController.checkProductInCart(
                          '$refId@${product.varient.varientCode}', addedFrom),
                      quantity: cartController.getCurrentQuantity(
                          '$refId@${product.varient.varientCode}', addedFrom),
                      onAdd: stateController.isLogin.value
                          ? () async {
                              stateController.showLoader.value = true;
                              bool isCheckedActivate =
                                  await stateController.getUserIsActive();
                              if (isCheckedActivate) {
                                // if (stateController.isActivate.value) {
                                var valid = true;
                                var msg = 'Something went wrong!';

                                Price? price = product.varient.price;
                                // this.refId, this.addedFrom,

                                await cartController.addToCart(
                                    '${product!.id}@${product!.varient!.varientCode}',
                                    'CATEGORY',
                                    1,
                                    product!.varient!.price,
                                    product,
                                    null,
                                    RuleConfig(),
                                    Constraint(),
                                    product!.varient!);
                              } else {
                                // Navigator.of(context).pop();
                                snackBarClass.showToast(
                                    context, 'Your profile is not active yet');
                              }
                              stateController.showLoader.value = false;
                            }
                          : () {
                              stateController.setCurrentTab(3);
                              snackBarClass.showToast(
                                  context, 'Please Login to preoceed');
                            },
                      onDecrease: () async {
                        stateController.showLoader.value = true;
                        Price? price = product.varient.price;
                        if (stateController.isLogin.value) {
                          var valid = true;
                          var msg = 'Something went wrong!';
                          var data;
                          if (Get.isRegistered<DealController>(
                              tag: addedFrom!)) {
                            price = dealPrice;
                            var dealController =
                                Get.find<DealController>(tag: addedFrom!);
                            data = await dealController.checkValidDeal(
                                refId!,
                                'negative',
                                '$refId@${product.varient.varientCode}');
                            valid = !data['error'];
                            msg = data['msg'];
                          }
                          if (valid) {
                            if (addedFrom == 'SCOIN') {
                              await cartController.addToCartScoins(
                                  '$refId@${product.varient.varientCode}',
                                  addedFrom!,
                                  -1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  product.varient);
                            } else if (addedFrom == 'MSD') {
                              await cartController.addToCartMSD(
                                  '$refId@${product.varient.varientCode}',
                                  addedFrom!,
                                  -1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  product.varient);
                            } else {
                              await cartController.addToCart(
                                  '$refId@${product.varient.varientCode}',
                                  addedFrom!,
                                  -1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  product.varient);
                            }
                          } else if (data['type'] == 'maxNumberExceeded') {
                            snackBarClass.showToast(context, msg);
                            await cartController.addToCart(
                                '${product!.id}@${product!.varient!.varientCode}',
                                'CATEGORY',
                                1,
                                product!.varient!.price,
                                product,
                                null,
                                RuleConfig(),
                                Constraint(),
                                product!.varient!);
                          } else {
                            await cartController.addToCart(
                                '$refId@${product.varient.varientCode}',
                                addedFrom!,
                                -1,
                                price,
                                product,
                                null,
                                ruleConfig,
                                constraint,
                                product.varient);
                          }
                        } else {
                          stateController.setCurrentTab(3);
                          snackBarClass.showToast(
                              context, 'Please Login to preoceed');
                        }
                        stateController.showLoader.value = false;
                      },
                      onIncrease: () async {
                        stateController.showLoader.value = true;
                        if (stateController.isLogin.value) {
                          var valid = true;
                          var msg = 'Something went wrong!';
                          Price? price = product.varient.price;
                          if (Get.isRegistered<DealController>(
                              tag: addedFrom!)) {
                            var dealController =
                                Get.find<DealController>(tag: addedFrom!);
                            var data = await dealController.checkValidDeal(
                                refId!,
                                'positive',
                                '$refId@${product.varient.varientCode}');
                            valid = !data['error'];
                            msg = data['msg'];
                            price = dealPrice;
                          }
                          if (valid) {
                            if (addedFrom == 'SCOIN') {
                              await cartController.addToCartScoins(
                                  '$refId@${product.varient.varientCode}',
                                  addedFrom!,
                                  1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  product.varient);
                            } else if (addedFrom == 'MSD') {
                              await cartController.addToCartMSD(
                                  '$refId@${product.varient.varientCode}',
                                  addedFrom!,
                                  1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  product.varient);
                            } else {
                              await cartController.addToCart(
                                  '$refId@${product.varient.varientCode}',
                                  addedFrom!,
                                  1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  product.varient);
                            }
                          } else {
                            stateController.setCurrentTab(3);
                            snackBarClass.showToast(context, msg);
                          }
                        }
                        stateController.showLoader.value = false;
                      },
                    ),
                  ),
                );
              }),
              (product!.tags!.length > 0 &&
                      addedFrom != 'TAGS_PRODUCT' &&
                      addedFrom != 'DEAL')
                  ? Positioned(
                      top: 0,
                      child: Card(
                          color: AppColors.secondaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5))),
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                product!.tags![0].name!,
                                style: TextStyles.body
                                    .copyWith(color: AppColors.white),
                              ))))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  productCheckoutListWidget(context, cartController) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cartController.cartProducts.length,
        itemBuilder: (_, index) {
          var currentKey =
              cartController.cartProducts.value.keys.elementAt(index);
          var currentProduct = cartController.cartProducts.value[currentKey]!;
          var minOrder = (currentProduct.constraint != null &&
                  currentProduct.constraint.minimumOrder != null &&
                  currentProduct.constraint.minimumOrder > 0)
              ? currentProduct.constraint!.minimumOrder
              : 1;
          return currentProduct.products!.isNotEmpty
              ? SizedBox() // TODO add multi design
              : checkoutProductCard(
                  currentProduct.product,
                  currentProduct.ref!.id,
                  'CART',
                  currentProduct.price,
                  currentProduct.ruleConfig,
                  currentProduct.constraint,
                  context);

          //   Column(
          // children: [
          //   currentProduct.products!.isNotEmpty
          //       ? SizedBox(
          //           width: MediaQuery.of(context).size.width,
          //           child: Column(
          //             children: [
          //               Row(children: <Widget>[
          //                 SizedBox(
          //                     width: MediaQuery.of(context).size.width * .1,
          //                     child: const Divider()),
          //                 FitText(
          //                   '${currentProduct.name}',
          //                   style: TextStyles.headingFont
          //                       .copyWith(color: AppColors.primeColor),
          //                 ),
          //                 const Expanded(child: Divider()),
          //               ]),
          //               Row(
          //                 children: [
          //                   SizedBox(
          //                     width: MediaQuery.of(context).size.width * .73,
          //                     child: ListView.builder(
          //                       shrinkWrap: true,
          //                       physics: const BouncingScrollPhysics(),
          //                       scrollDirection: Axis.vertical,
          //                       itemCount: currentProduct.products!.length,
          //                       itemBuilder: (_, pIndex) {
          //                         var currentInnerProduct =
          //                             currentProduct.products![pIndex];
          //                         return ListTile(
          //                           dense: false,
          //                           visualDensity:
          //                               const VisualDensity(vertical: 3),
          //                           leading: ImageBox(
          //                             '${currentInnerProduct.images![0]}',
          //                             width: 80,
          //                             height: 80,
          //                             fit: BoxFit.contain,
          //                           ),
          //                           title: FitText(
          //                             currentInnerProduct
          //                                 .name!.defaultText!.text!,
          //                             style: TextStyles.headingFont,
          //                             align: TextAlign.start,
          //                           ),
          //                           subtitle: Text(
          //                             '${currentInnerProduct.varient!.weight.toString()} ${CodeHelp.formatUnit(currentInnerProduct!.varient!.unit)}',
          //                             style: TextStyles.body,
          //                           ),
          //                         );
          //                       },
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: 100,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       children: [
          //                         Text(
          //                           '${Helper.getFormattedNumber(currentProduct.price!.offerPrice * currentProduct.count).toString()}${CodeHelp.euro}',
          //                           style: TextStyles.headingFont,
          //                         ),
          //                         Card(
          //                           color: AppColors.primeColor,
          //                           shape: RoundedRectangleBorder(
          //                               borderRadius:
          //                                   BorderRadius.circular(12)),
          //                           child: Row(
          //                             mainAxisSize: MainAxisSize.min,
          //                             children: [
          //                               IconButton(
          //                                 padding: const EdgeInsets.all(4),
          //                                 constraints: const BoxConstraints(),
          //                                 onPressed: () async {
          //                                   if (stateController
          //                                       .isLogin.value) {
          //                                     isLoading.value = true;

          //                                     await cartController.addToCart(
          //                                         '${currentProduct.ref!.id}',
          //                                         currentProduct.ref!.name!,
          //                                         -minOrder,
          //                                         currentProduct.price,
          //                                         null,
          //                                         currentProduct.products,
          //                                         currentProduct.ruleConfig,
          //                                         currentProduct.constraint,
          //                                         null,
          //                                         mutliProductName:
          //                                             currentProduct.name ??
          //                                                 "");
          //                                   }
          //                                   isLoading.value = false;
          //                                 },
          //                                 icon: Icon(
          //                                   Icons.remove_circle_outline,
          //                                   color: Colors.white,
          //                                   size: FontSizes.title,
          //                                 ),
          //                               ),
          //                               Text(
          //                                   cartController
          //                                       .getCurrentQuantity(
          //                                           '${currentProduct.ref!.id}',
          //                                           '')
          //                                       .toString(),
          //                                   style: TextStyles.headingFont
          //                                       .copyWith(
          //                                           color: Colors.white)),
          //                               IconButton(
          //                                 padding: const EdgeInsets.all(4),
          //                                 constraints: const BoxConstraints(),
          //                                 onPressed: () async {
          //                                   if (stateController
          //                                       .isLogin.value) {
          //                                     isLoading.value = true;
          //                                     var valid = false;
          //                                     var msg =
          //                                         'Something went wrong!';

          //                                     if (currentProduct.ruleConfig !=
          //                                             null ||
          //                                         currentProduct.constraint !=
          //                                             null) {
          //                                       dynamic data = await Helper
          //                                           .checkProductValidtoAddinCart(
          //                                               currentProduct
          //                                                   .ruleConfig,
          //                                               currentProduct
          //                                                   .constraint,
          //                                               currentProduct
          //                                                       .ref!.id ??
          //                                                   '',
          //                                               currentProduct
          //                                                       .ref!.id ??
          //                                                   '');
          //                                       valid = !data['error'];
          //                                       msg = data['msg'];
          //                                     }
          //                                     if (valid) {
          //                                       await cartController.addToCart(
          //                                           '${currentProduct.ref!.id}',
          //                                           currentProduct.ref!.name!,
          //                                           minOrder,
          //                                           currentProduct.price,
          //                                           null,
          //                                           currentProduct.products,
          //                                           currentProduct.ruleConfig,
          //                                           currentProduct.constraint,
          //                                           null,
          //                                           mutliProductName:
          //                                               currentProduct.name ??
          //                                                   '');
          //                                     } else {
          //                                       snackBarClass.showToast(
          //                                           context, msg);
          //                                     }
          //                                   }
          //                                   isLoading.value = false;
          //                                 },
          //                                 icon: Icon(
          //                                   Icons.add_circle_outline,
          //                                   color: Colors.white,
          //                                   size: FontSizes.title,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ],
          //           ),
          //         )
          //       : SizedBox(
          //           width: MediaQuery.of(context).size.width,
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               ListTile(
          //                 dense: false,
          //                 visualDensity: const VisualDensity(vertical: 3),
          //                 leading: ImageBox(
          //                   currentProduct.product!.images![0],
          //                   width: 80,
          //                   height: 80,
          //                   fit: BoxFit.contain,
          //                 ),
          //                 title: FitText(
          //                   currentProduct.product!.name!.defaultText!.text!,
          //                   style: TextStyles.headingFont,
          //                   align: TextAlign.start,
          //                 ),
          //                 subtitle: Row(
          //                   children: [
          //                     Text(
          //                       '${currentProduct.product!.varient!.weight.toString()} ${CodeHelp.formatUnit(currentProduct.product!.varient!.unit)}',
          //                       style: TextStyles.body,
          //                     ),
          //                     Text(
          //                         '/${Helper.getFormattedNumber(currentProduct.price!.offerPrice!)}${CodeHelp.euro} ',
          //                         style: TextStyles.body),
          //                   ],
          //                 ),
          //                 trailing: Column(
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: [
          //                     Text(
          //                       '${Helper.getFormattedNumber(currentProduct.price!.offerPrice * currentProduct.count).toString()}${CodeHelp.euro}',
          //                       style: TextStyles.headingFont,
          //                     ),
          //                     Card(
          //                       color: AppColors.primeColor,
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(12)),
          //                       child: Row(
          //                         mainAxisSize: MainAxisSize.min,
          //                         children: [
          //                           IconButton(
          //                             padding: const EdgeInsets.all(4),
          //                             constraints: const BoxConstraints(),
          //                             onPressed: () async {
          //                               isLoading.value = true;
          //                               if (stateController.isLogin.value) {
          //                                 await cartController.addToCart(
          //                                   '${currentProduct.ref!.id}',
          //                                   currentProduct.ref!.name!,
          //                                   -minOrder,
          //                                   currentProduct.price,
          //                                   currentProduct.product,
          //                                   null,
          //                                   currentProduct.ruleConfig,
          //                                   currentProduct.constraint,
          //                                   currentProduct.product.varient,
          //                                 );
          //                               } else {
          //                                 stateController.setCurrentTab(3);

          //                                 snackBarClass.showToast(context,
          //                                     'Please Login to preoceed');
          //                               }
          //                               isLoading.value = false;
          //                             },
          //                             icon: Icon(
          //                               Icons.remove_circle_outline,
          //                               color: Colors.white,
          //                               size: FontSizes.title,
          //                             ),
          //                           ),
          //                           Text(
          //                             cartController
          //                                 .getCurrentQuantity(
          //                                     '${currentProduct.ref!.id}', '')
          //                                 .toString(),
          //                             style: TextStyles.headingFont
          //                                 .copyWith(color: Colors.white),
          //                           ),
          //                           IconButton(
          //                             padding: const EdgeInsets.all(4),
          //                             constraints: const BoxConstraints(),
          //                             onPressed: () async {
          //                               isLoading.value = true;
          //                               if (stateController.isLogin.value) {
          //                                 var valid = false;
          //                                 var msg = 'Something went wrong!';

          //                                 if (currentProduct.ruleConfig !=
          //                                         null ||
          //                                     currentProduct.constraint !=
          //                                         null) {
          //                                   dynamic data = await Helper
          //                                       .checkProductValidtoAddinCart(
          //                                           currentProduct.ruleConfig,
          //                                           currentProduct.constraint,
          //                                           currentProduct.ref!.id ??
          //                                               "",
          //                                           currentProduct.ref!.id ??
          //                                               '');
          //                                   valid = !data['error'];
          //                                   msg = data['msg'];
          //                                 }
          //                                 if (valid) {
          //                                   await cartController.addToCart(
          //                                       '${currentProduct.ref!.id}',
          //                                       currentProduct.ref!.name!,
          //                                       minOrder,
          //                                       currentProduct.price,
          //                                       currentProduct.product,
          //                                       null,
          //                                       currentProduct.ruleConfig,
          //                                       currentProduct.constraint,
          //                                       currentProduct
          //                                           .product.varient);
          //                                 } else {
          //                                   snackBarClass.showToast(
          //                                       context, msg);
          //                                 }
          //                               }
          //                               isLoading.value = false;
          //                             },
          //                             icon: Icon(
          //                               Icons.add_circle_outline,
          //                               color: Colors.white,
          //                               size: FontSizes.title,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Row(
          //                 children: [
          //                   cartCheckoutButtons(
          //                       context, cartController, currentKey),
          //                   MaterialButton(
          //                     onPressed: () async {
          //                       isLoading.value = true;
          //                       await cartController.removeProduct(
          //                           currentKey, '');
          //                       isLoading.value = false;
          //                     },
          //                     child: Row(
          //                       children: [
          //                         const Icon(
          //                           Icons.delete,
          //                           size: 16,
          //                           color: Colors.grey,
          //                         ),
          //                         Text(
          //                           'Remove',
          //                           style: TextStyles.body.copyWith(
          //                             color: Colors.grey,
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               )
          //             ],
          //           ),
          //         ),
          //   Obx(() => checkoutClicked.value &&
          //           !cartController.checktOrderRefAvailable(
          //               cartController.cartProducts.value[currentKey]!.ref)
          //       ? recpmmondedCheckoutProduct(
          //           context, cartController, currentKey)
          //       : const SizedBox())
          // ],
          // );
        },
      ),
    );
  }

  recpmmondedCheckoutProduct(context, cartController, currentKey) {
    var prod = cartController
        .getRecommendedProd(cartController.cartProducts.value[currentKey]!.ref);
    return prod.productAvailabilityStatus != null
        ? prod.productAvailabilityStatus!.recommendedProducts!.isNotEmpty
            ? Column(
                children: [
                  Text('Recommended Products', style: TextStyles.headingFont),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 160,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: prod.productAvailabilityStatus!
                            .recommendedProducts!.length,
                        itemBuilder: (_, index) {
                          var curProd = prod.productAvailabilityStatus!
                              .recommendedProducts![index];
                          return ProductCard(
                              curProd,
                              curProd.id,
                              'RECOMMEDED_PRODUCT',
                              curProd.varient!.price!,
                              null,
                              null);
                        },
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox()
        : const SizedBox();
  }

  cartCheckoutButtons(context, cartController, currentKey) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () async {
            isLoading.value = true;
            await cartController.createSaveLater(
                cartController.cartProducts[currentKey], currentKey);
            isLoading.value = false;
          },
          icon: const Icon(
            Icons.bookmark_add_outlined,
            size: 16,
            color: Colors.grey,
          ),
          label: Text(
            "Save for later",
            style: TextStyles.body.copyWith(color: Colors.grey),
          ),
        )
      ],
    );
  }
}
