import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/customer/favorite.insight.detail.dart';
import 'package:amber_bird/data/customer/wish_list.insight.detail.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/controller-generator.dart';

class WishListPage extends StatelessWidget {
  bool search = false;
  WishlistController wishlistController = Get.find<WishlistController>();
  CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  Rx<WishList> wishList = WishList().obs;

  getWishList() async {
    Ref custRef = await Helper.getCustomerRef();
    var response = await ClientService.post(
        path: 'wishList/search', payload: {"customerId": custRef.id});
    if (response.statusCode == 200) {
      if (response.data.length > 0) {
        wishList.value =
            WishList.fromMap(response.data[0] as Map<String, dynamic>);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 150,
            leadingWidth: 100,
            backgroundColor: AppColors.primeColor,
            title: Column(
              children: [
                Lottie.asset('assets/wish-list.json',
                    width: 100, fit: BoxFit.cover),
                Text(
                  'My Wishlist',
                  style: TextStyles.headingFont.copyWith(color: Colors.white),
                ),
              ],
            ),
            leading: MaterialButton(
                onPressed: () {
                  Modular.to.navigate('../home/main');
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    Text(
                      'Back',
                      style: TextStyles.bodyFont.copyWith(color: Colors.white),
                    )
                  ],
                )),
          ),
          wishlistController.wishlistProducts.isNotEmpty
              ? Expanded(
                  child: MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: wishlistController.wishlistProducts.length,
                    itemBuilder: (_, index) {
                      var currentKey = wishlistController
                          .wishlistProducts.value.keys
                          .elementAt(index);
                      var curwishList =
                          wishlistController.wishlistProducts[currentKey]!;
                      return WishlistTile(context, curwishList);
                    },
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Lottie.asset('assets/no-data.json',
                            width: MediaQuery.of(context).size.width * .5,
                            fit: BoxFit.cover),
                        Expanded(
                          child: Text(
                            'No product selected for wishlist.',
                            style: TextStyles.bodyFont,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  WishlistTile(BuildContext context, Favorite curwishList) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Modular.to.pushNamed('product/${curwishList.product!.id}');
              },
              child: ImageBox(
                  curwishList.product != null
                      ? curwishList.product!.images![0] ?? ''
                      : curwishList.products![0].images![0],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover),
            ),
            Text(
              '${curwishList.product!.name!.defaultText!.text}',
              style: TextStyles.bodyFontBold,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PriceTag(
                        curwishList.product!.varient!.price!.offerPrice
                            .toString(),
                        curwishList.product!.varient!.price!.actualPrice
                            .toString()),
                    Text(
                      '${curwishList.product!.varient!.weight} ${CodeHelp.formatUnit(curwishList.product!.varient!.unit)} ',
                      style: TextStyles.bodyFont,
                    ),
                  ],
                ),
                MaterialButton(
                  color: AppColors.primeColor,
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    Price price = Price();
                    if (curwishList.products != null &&
                        curwishList.products!.length > 0) {
                      price = curwishList.products![0].varient!.price!;
                    } else {
                      price = curwishList.product!.varient!.price!;
                    }
                    await cartController.addToCart(
                        curwishList.ref!.id ?? '',
                        'WISHLIST',
                        1,
                        price,
                        curwishList.product,
                        curwishList.products,
                        null,
                        null,
                        curwishList.product!.varient);
                    await wishlistController
                        .removeWishList(curwishList.ref!.id ?? '');
                  },
                  child: Text(
                    'Add to cart',
                    style:
                        TextStyles.bodyFontBold.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
