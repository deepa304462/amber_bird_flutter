import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/customer/favorite.insight.detail.dart';
import 'package:amber_bird/data/customer/wish_list.insight.detail.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class WishListPage extends StatelessWidget {
  bool search = false;
  WishlistController wishlistController = Get.find<WishlistController>();
  CartController cartController = Get.find<CartController>();
  Rx<WishList> wishList = WishList().obs;

  getWishList() async {
    Ref custRef = await Helper.getCustomerRef();
    var response = await ClientService.post(
        path: 'wishList/search', payload: {"customerId": custRef.id});
    if (response.statusCode == 200) {
      // log(response.data.toString());
      // List<WishList> oList = ((response.data as List<dynamic>?)
      //         ?.map((e) => WishList.fromMap(e as Map<String, dynamic>))
      //         .toList() ??
      //     []);
      if (response.data.length > 0) {
        wishList.value =
            WishList.fromMap(response.data[0] as Map<String, dynamic>);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Modular.to.navigate('../home/main');
                    },
                    icon: const Icon(Icons.arrow_back)),
                Text(
                  'Wishlist',
                  style: TextStyles.headingFont,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primeColor),
                borderRadius: BorderRadius.circular(5),
              ),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .70),
              padding: const EdgeInsets.all(8.0),
              child: wishlistController.wishlistProducts.value.length > 0
                  ? MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount:
                          wishlistController.wishlistProducts.value.length,
                      itemBuilder: (_, index) {
                        var currentKey = wishlistController
                            .wishlistProducts.value.keys
                            .elementAt(index);
                        var curwishList =
                            wishlistController.wishlistProducts[currentKey]!;
                        return WishlistTile(context, curwishList);
                      },
                    )
                  : Center(
                      child: Text(
                        'No Products added to wishlist yet',
                        style: TextStyles.body,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  WishlistTile(BuildContext context, Favorite curwishList) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.grey)),
        child: Column(
          children: [ 
            ImageBox(
              curwishList.product != null
                  ? curwishList.product!.images![0] ?? ''
                  : curwishList.products![0].images![0],
              width: 200,
              height: 150,
            ),
            TextButton(
              onPressed: () async { 
                Price price = Price();
                if (curwishList.products!.length > 0) {
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
                    curwishList.products);
                await wishlistController
                    .removeWishList(curwishList.ref!.id ?? '');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add to cart'),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: wishlistController
                              .checkIfProductWishlist(curwishList.product!.id)
                          ? AppColors.primeColor
                          : const Color(0xFFA6A3A0),
                    ),
                    onPressed: () => {
                      wishlistController.addToWishlist(curwishList.product!.id,
                          curwishList.product, null, '')
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // Modular.to
        //     .navigate('/home/order-detail', arguments: {'id': curwishList.id});
      },
    );
  }
}
