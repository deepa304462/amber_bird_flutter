import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/appBar/location-widget.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/search-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            locationWidget(),
            ImageBox(
              "0ad51820-35be-4a37-8a41-fb3915c1b2a0",
              width: 200,
              height: 50,
            ),
            SizedBox(
              child: Row(
                children: [
                  // cartWidget(context),
                  IconButton(
                      onPressed: () => {Modular.to.navigate('/home/refer')},
                      icon: Icon(Icons.share)),
                  IconButton(onPressed: () => {}, icon: Icon(Icons.layers))
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 2,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchWidget(),
          ],
        )
      ],
    );
  }

  cartWidget(context) {
    final CartController cartController = Get.find();
    final Controller stateController = Get.find();
    return Obx(() {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          InkWell(
            onTap: () {
              if (stateController.isLogin.value) {
                stateController.navigateToUrl('/home/cart');
              }
            },
            child: Card(
              color: AppColors.primeColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: -2,
            right: -2,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(cartController.cartProducts.value.length.toString(),
                  style: TextStyles.bodyFontBold),
            )),
          ),
        ],
      );
    });
  }
}
