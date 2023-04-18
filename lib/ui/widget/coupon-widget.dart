import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/coupon_code/reward.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/controller-generator.dart';

class CouponWidget extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final Controller stateController = Get.find();
  @override
  Widget build(BuildContext context) {
    final CartController cartController =
        ControllerGenerator.create(CartController(), tag: 'cartController');

    controller.text = cartController.couponName.toString();
    return Obx(() {
      controller.text = cartController.couponName.toString();
      return FractionallySizedBox(
        widthFactor: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Promo Code',
              style: TextStyles.headingFont,
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: MaterialButton(
                  color: AppColors.primeColor,
                  onPressed: () async {
                    print(controller.value.text);

                    stateController.showLoader.value = true;
                    var coupon = await cartController
                        .searchCoupon(controller.value.text);
                    if (coupon != null) {
                      var data =
                          await cartController.isApplicableCoupun(coupon);
                      if (data) {
                        cartController.selectedCoupon.value = coupon;
                        cartController.calculateTotalCost();
                        await cartController.createOrder();
                        // controller.text = cartController.couponName.toString();
                        cartController.setSearchVal(coupon.couponCode);
                        stateController.showLoader.value = false;
                        snackBarClass.showToast(context, 'coupon is valid ');
                      } else {
                        snackBarClass.showToast(
                            context, 'coupon is not valid ');
                      }
                    } else {
                      snackBarClass.showToast(context, 'Not found any coupon');
                    }
                  },
                  child: Text(
                    'APPLY',
                    style:
                        TextStyles.headingFont.copyWith(color: AppColors.white),
                  ),
                ),
                labelText: "Apply promo code",
                labelStyle:
                    TextStyles.titleFont.copyWith(color: AppColors.grey),
                contentPadding: const EdgeInsets.all(7.0),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            MaterialButton(
                visualDensity: VisualDensity.compact,
                child: Text(
                  'View available promo codes',
                  style: TextStyles.body.copyWith(color: Colors.grey),
                ),
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                })
          ],
        ),
      );
    });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // List<String> matchQuery = [];
    print(query);
    cartController.getsearchData(query);
    return Obx(
      () => ListView.builder(
        itemCount: cartController.searchCouponList.value.length,
        itemBuilder: (context, index) {
          var coupon = cartController.searchCouponList.value[index];
          return Column(
            children: [
              ListTile(
                onTap: () {
                  close(context, null);
                },
                dense: false,
                leading: Lottie.asset(
                  'assets/gift-pack.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
                horizontalTitleGap: 1,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coupon.couponCode ?? '',
                        style: TextStyles.headingFont
                            .copyWith(color: AppColors.primeColor)),
                    Text(getConditionText(coupon.reward)),
                  ],
                ),
                trailing: SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        visualDensity: VisualDensity.compact,
                        onPressed: () async {
                          stateController.showLoader.value = true;
                          var data =
                              await cartController.isApplicableCoupun(coupon);
                          if (data) {
                            cartController.selectedCoupon.value = coupon;
                            cartController.calculateTotalCost();
                            await cartController.createOrder();
                            // controller.text = cartController.couponName.toString();
                            cartController.setSearchVal(coupon.couponCode);
                            stateController.showLoader.value = false;
                            snackBarClass.showToast(
                                context, 'coupon is valid ');
                            close(
                                context, cartController.couponName.toString());
                          } else {
                            snackBarClass.showToast(
                                context, 'coupon is not valid ');
                          }
                        },
                        color: AppColors.primeColor,
                        child: Text(
                          'Apply',
                          style: TextStyles.bodyFontBold
                              .copyWith(color: Colors.white),
                        )),
                  ),
                ),
                subtitle: Column(
                  children: [
                    (coupon.description != null &&
                            coupon.description!.defaultText != null)
                        ? Text(coupon.description!.defaultText!.text!)
                        : const SizedBox(),
                  ],
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }

  String getConditionText(Reward? reward) {
    if (reward!.discountPercent != null && reward!.discountPercent > 0) {
      return 'Get flat ${reward!.discountPercent}% discount on your purchase.';
    } else if (reward!.discountUptos != null && reward!.discountUptos > 0) {
      return 'Get upto ${reward!.discountUptos}% discount on your purchase.';
    } else if (reward!.flatDiscount != null && reward!.flatDiscount > 0) {
      return 'Get flat discount of ${reward!.flatDiscount} on your purchase.';
    }

    return '';
  }
}
