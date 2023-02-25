import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveLater extends StatelessWidget {
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  RxBool checkoutClicked = false.obs;
  TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cartController.clearCheckout();
    return Obx(
      () => cartController.saveLaterProducts.length > 0
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Products',
                    style: TextStyles.titleLargeBold.copyWith(fontSize: 20),
                  ),
                  saveLaterData(context, cartController),
                ],
              ),
            )
          : Text(
              'Saved Products',
              style: TextStyles.titleLargeBold.copyWith(fontSize: 20),
            ),
    );
  }

  saveLaterData(context, cartController) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: cartController.saveLaterProducts.length,
      itemBuilder: (_, index) {
        var currentKey =
            cartController.saveLaterProducts.value.keys.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            children: [
              cartController
                      .saveLaterProducts.value[currentKey]!.products!.isNotEmpty
                  ? Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 113, 116, 122))),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: cartController.saveLaterProducts
                                .value[currentKey]!.products!.length,
                            itemBuilder: (_, pIndex) {
                              var currentProduct = cartController
                                  .saveLaterProducts
                                  .value[currentKey]!
                                  .products![pIndex];
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    ListTile(
                                      dense: false,
                                      visualDensity: VisualDensity(vertical: 3),
                                      leading: ImageBox(
                                        cartController
                                            .cartProducts
                                            .value[currentKey]!
                                            .product!
                                            .images![0],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                      title: FitText(
                                        cartController
                                            .cartProducts
                                            .value[currentKey]!
                                            .product!
                                            .name!
                                            .defaultText!
                                            .text!,
                                        style: TextStyles.bodyFontBold,
                                        align: TextAlign.start,
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                              '${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.unit}'),
                                          Text(
                                              '${cartController.saveLaterProducts[currentKey]!.count!.toString()} * ${CodeHelp.euro}${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.price!.offerPrice!} '),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        saveLaterButtons(context,
                                            cartController, currentKey),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ListTile(
                          dense: false,
                          visualDensity: VisualDensity(vertical: 3),
                          leading: ImageBox(
                            cartController.saveLaterProducts.value[currentKey]!
                                .product!.images![0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          title: FitText(
                            cartController.saveLaterProducts.value[currentKey]!
                                .product!.name!.defaultText!.text!,
                            style: TextStyles.bodyFontBold,
                            align: TextAlign.start,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                  '${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.unit}'),
                              Text(
                                  '${cartController.saveLaterProducts[currentKey]!.count!.toString()} * ${CodeHelp.euro}${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.price!.offerPrice!} '),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            saveLaterButtons(
                                context, cartController, currentKey),
                          ],
                        ),
                      ],
                    )
            ],
          ),
        );
      },
    );
  }

  saveLaterButtons(context, cartController, currentKey) {
    return Row(
      children: [
        TextButton.icon(
            onPressed: () async {
              stateController.showLoader.value = true;
              await cartController.addTocartSaveLater(currentKey);
              stateController.showLoader.value = false;
            },
            icon: const Icon(Icons.flash_on),
            label: const Text('Add to cart')),
        TextButton.icon(
            onPressed: () async {
              stateController.showLoader.value = true;
              await cartController.removeSaveLater(currentKey);
              stateController.showLoader.value = false;
            },
            icon: const Icon(Icons.outbox),
            label: const Text("Delete"))
      ],
    );
  }
}
