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
                    cartController.calculatedPayment.value.totalAmount !=
                        null &&
                    cartController.calculatedPayment.value.totalAmount
                            as double >
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
        body: SizedBox());
  }
}
