import 'dart:async';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/widget/coupon-widget.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:amber_bird/ui/element/snackbar.dart';

class CheckoutWidget extends StatelessWidget {
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
    checkoutLists.clear();
    checkoutLists.add(
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Column(
                children: [shippingAddress(context), Divider()],
              ),
            ],
          ),
          childCount: 1,
        ),
      ),
    );
    checkoutLists.add(
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              _saveLaterAndCheckoutOptions(context),
          childCount: 1,
        ),
      ),
    );

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
              Navigator.pop(context);
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Cart',
              style: TextStyles.bodyFont.copyWith(color: Colors.white),
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
                            '${(cartController.calculatedPayment.value.totalAmount != null ? Helper.formatNumberTwodigit(Helper.getFormattedNumber(cartController.calculatedPayment.value.totalAmount as double)) : 0.00)}${CodeHelp.euro}',
                            style: TextStyles.bodyFont.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      MaterialButton(
                        color: Colors.green,
                        visualDensity: const VisualDensity(horizontal: 4),
                        onPressed: () async {
                          if (!isLoading.value) {
                            isLoading.value = true;
                            var checkoutResp =
                                await cartController.createPayment();
                            checkoutClicked.value = true;
                            checkoutClicked.refresh();
                            if (checkoutResp == null || checkoutResp['error']) {
                              // ignore: use_build_context_synchronously
                              snackBarClass.showToast(
                                  context,
                                  checkoutResp['msg'] ??
                                      'Something went wrong');

                              isLoading.value = false;
                            } else {
                              if (cartController
                                      .checkoutData.value!.allAvailable ==
                                  true) {
                                Timer(Duration(seconds: 5), () async {
                                  var paymentData =
                                      await cartController.searchPayment();
                                  if (paymentData['data'] != '') {
                                    Modular.to.navigate('/home/inapp',
                                        arguments: paymentData['data']);
                                    isLoading.value = false;
                                  } else {
                                    snackBarClass.showToast(
                                        context, paymentData['msg']);
                                    isLoading.value = false;
                                  }
                                });
                              } else {
                                isLoading.value = false;
                                // ignore: use_build_context_synchronously
                                snackBarClass.showToast(
                                    context, 'All product not available');
                                isLoading.value = false;
                              }
                            }
                          }
                        },
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          isLoading.value ? 'Loading' : 'Pay Order',
                          style: TextStyles.bodyFont
                              .copyWith(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ))
              : const SizedBox(),
        ),
      ),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: isLoading.value,
            child: (checkoutLists.isNotEmpty)
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
                  ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => isLoading.value
                    ? const LoadingWithLogo()
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  shippingAddress(context) {
    LocationController locationController = Get.find();
    // log(locationController.addressData.toString());
    var add = locationController.addressData;
    return Obx(
      () => Container(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Shipping Address',
                      style: TextStyles.headingFont,
                    ),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    elevation: 0,
                    onPressed: (() =>
                        {Modular.to.pushNamed('/widget/address-list')}),
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          style: TextStyles.titleFont
                              .copyWith(color: AppColors.primeColor),
                        ),
                        Icon(
                          Icons.edit,
                          color: AppColors.primeColor,
                          size: 15,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Modular.to.pushNamed('/widget/address-list');
                },
                child: Card(
                  color: Colors.grey.shade300,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(add.value.name ?? '',
                                  style: TextStyles.bodyFontBold),
                              Text(
                                  '(${add.value.zipCode ?? ''}, ${add.value.houseNo ?? ''} ${add.value.line1 ?? ''} ${add.value.city ?? ''} ${add.value.country ?? ''})',
                                  style: TextStyles.body.copyWith())
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView _saveLaterAndCheckoutOptions(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: CouponWidget(),
              ),
              Divider(),
              Container(
                color: AppColors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'S-Coins/S-Points',
                        style: TextStyles.headingFont,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              'You will be rewarded with ${cartController.calculatedPayment.value.totalSCoinsEarned} SCOINS & ${cartController.calculatedPayment.value.totalSPointsEarned} SPOINTS on this order.',
                              style: TextStyles.body,
                            ),
                          ),
                          cartController.calculatedPayment.value
                                          .totalSavedAmount !=
                                      null &&
                                  cartController.calculatedPayment.value
                                          .totalSavedAmount !=
                                      0.00
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    'You will save ${CodeHelp.euro}${Helper.getFormattedNumber(cartController.calculatedPayment.value.totalSavedAmount as double)} on this purchase',
                                    style: TextStyles.body,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ]),
              ),
              Divider(),
              Text(
                'Order Summary',
                style: TextStyles.headingFont
                    .copyWith(color: AppColors.primeColor),
              ),
              cartController.calculatedPayment.value.discountAmount != null &&
                      cartController.calculatedPayment.value.discountAmount !=
                          0.00
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coupon discount Amount',
                          style: TextStyles.body,
                        ),
                        Text(
                          '${(cartController.calculatedPayment.value.discountAmount != null ? cartController.calculatedPayment.value.discountAmount : 0.0).toStringAsFixed(2)}${CodeHelp.euro}',
                          style: TextStyles.headingFont,
                        ),
                      ],
                    )
                  : const SizedBox(),
              cartController.calculatedPayment.value
                              .totalAdditionalDiscountAmount !=
                          null &&
                      cartController.calculatedPayment.value
                              .totalAdditionalDiscountAmount !=
                          0.00
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Membership Discount',
                          style: TextStyles.body,
                        ),
                        Text(
                          '${(cartController.calculatedPayment.value.totalAdditionalDiscountAmount ?? 0.0).toStringAsFixed(2)}${CodeHelp.euro}',
                          style: TextStyles.headingFont,
                        ),
                      ],
                    )
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipping Fee',
                    style: TextStyles.body,
                  ),
                  cartController.calculatedPayment.value.shippingAmount == 0.00
                      ? Text(
                          'Free',
                          style: TextStyles.titleFont
                              .copyWith(color: AppColors.green),
                        )
                      : Text(
                          '${Helper.getFormattedNumber((cartController.calculatedPayment.value.shippingAmount ?? 0))}${CodeHelp.euro}',
                          style: TextStyles.headingFont,
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax* (Inclusive)',
                    style: TextStyles.body,
                  ),
                  Text(
                    '${Helper.getFormattedNumber(cartController.calculatedPayment.value.appliedTaxAmount)}${CodeHelp.euro}',
                    style: TextStyles.headingFont,
                  ),
                ],
              ),
              (cartController.calculatedPayment.value.appliedTaxDetail !=
                          null &&
                      cartController
                          .calculatedPayment.value.appliedTaxDetail!.isNotEmpty)
                  ? Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: cartController.calculatedPayment.value
                                  .appliedTaxDetail!.length,
                              itemBuilder: (_, pIndex) {
                                var currentTax = cartController
                                    .calculatedPayment
                                    .value
                                    .appliedTaxDetail![pIndex];
                                return Text(
                                  currentTax.description ?? '',
                                  style: TextStyles.bodySm,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              cartController.calculatedPayment.value.totalAmount != null &&
                      cartController.calculatedPayment.value.totalAmount > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total ',
                          style: TextStyles.headingFont
                              .copyWith(color: AppColors.green),
                        ),
                        Text(
                          CodeHelp.euro +
                              (Helper.formatNumberTwodigit(
                                  Helper.getFormattedNumber(cartController
                                      .calculatedPayment
                                      .value
                                      .totalAmount as double))),
                          style: TextStyles.headingFont,
                        ),
                      ],
                    )
                  : const SizedBox(),
              cartController.calculatedPayment.value.totalSCoinsPaid != null &&
                      cartController.calculatedPayment.value.totalSCoinsPaid !=
                          0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total coins',
                          style: TextStyles.body,
                        ),
                        Text(
                          (cartController.calculatedPayment.value
                                  .totalSCoinsPaid as int)
                              .toString(),
                          style: TextStyles.headingFont,
                        ),
                      ],
                    )
                  : const SizedBox(),
              (cartController.calculatedPayment.value.refferalDiscountApplied !=
                          null &&
                      cartController
                          .calculatedPayment.value.refferalDiscountApplied!)
                  ? const Text('You will received 9% Referral discout')
                  : const SizedBox()
            ],
          ),
        ),
        // const Divider(),
        // SaveLater(),
      ],
    );
  }
}
