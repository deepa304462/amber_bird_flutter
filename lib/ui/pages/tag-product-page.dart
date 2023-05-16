import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/tag-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';

class TagProductPage extends StatelessWidget {
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();
  LocationController locationController = Get.find();
  final AppbarScrollController appbarScrollController = Get.find();
  final String? keyword;

  RxList<Address> addressList = <Address>[].obs;
  TagProductPage(this.keyword);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TagController tagController =
        Get.put(TagController(keyword ?? ''), tag: keyword ?? "");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: AppColors.primeColor,
        iconTheme: IconThemeData(color: AppColors.commonBgColor),
        leadingWidth: 50,
        leading: MaterialButton(
          onPressed: () {
            try {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Modular.to.navigate('../../home/main');
              }
            } catch (err) {
              Modular.to.pushNamed('../../home/main');
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 15,
          ),
        ),
        title: Text(
          Uri.decodeComponent(keyword!),
          style: TextStyles.body.copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Obx(
        () => MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: tagController.productList.length,
          itemBuilder: (_, index) {
            var currentProduct = tagController.productList[index];
            if (currentProduct.varient != null) {
              return ProductCard(currentProduct, currentProduct.id, 'TAG',
                  currentProduct.varient!.price!, null, null);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
