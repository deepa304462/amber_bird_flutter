import 'dart:developer';

import 'package:amber_bird/data/customer/favorite.insight.detail.dart';
import 'package:amber_bird/data/customer/wish_list.insight.detail.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class WishListPage extends StatelessWidget {
  bool search = false;
  Rx<WishList> wishList = WishList().obs;

  getWishList() async {
    Ref custRef = await Helper.getCustomerRef();
    var response = await ClientService.post(
        path: 'wishList/search', payload: {"customerId": custRef.id});
    if (response.statusCode == 200) {
      log(response.data.toString());
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
    getWishList();
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              IconButton(
                  onPressed: () {
                    Modular.to.navigate('../home/main');
                  },
                  icon: const Icon(Icons.arrow_back)),
              Text(
                'Wishlist',
                style: TextStyles.headingFont,
              )
            ]),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5),
              ),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .70),
              padding: const EdgeInsets.all(8.0),
              child: wishList.value.favorites != null
                  ? GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 6 / 8,
                              crossAxisSpacing: 10),
                      scrollDirection: Axis.vertical,
                      itemCount: wishList.value.favorites!.length,
                      shrinkWrap: true,
                      // ListView.builder(

                      //               scrollDirection: Axis.vertical,
                      //               physics: const BouncingScrollPhysics(),
                      //               itemCount: wishList.length,
                      itemBuilder: (_, index) {
                        var curwishList = wishList.value.favorites![index];
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
            // Text(
            //   '#${curwishList.id}',
            //   style: TextStyles.bodySm,
            // ),
            // Text(
            //   '# ${curwishList.id}',
            //   style: TextStyles.body,
            // ),
            // 0ad51820-35be-4a37-8a41-fb3915c1b2a0
            // )
            ImageBox(
              curwishList.product != null
                  ? curwishList.product!.images![0] ?? ''
                  : curwishList.products![0].images![0],
              width: 200,
              height: 200,
            )
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
