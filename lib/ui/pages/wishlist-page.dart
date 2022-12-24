import 'dart:developer';

import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/customer/wish_list.insight.detail.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class WishListPage extends StatelessWidget {
  bool search = false; 
  RxList<WishList> wishList = <WishList>[].obs;

  getWishList() async {
    Ref custRef = await Helper.getCustomerRef();
    var response = await ClientService.post(
        path: 'wishList/search',
        payload: {"customerId": custRef.id});
    if (response.statusCode == 200) {
      log(response.data.toString());
      List<WishList> oList = ((response.data as List<dynamic>?)
              ?.map((e) => WishList.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      wishList.value = oList;
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
              child: wishList.length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemCount: wishList.length,
                      itemBuilder: (_, index) {
                        var curwishList = wishList[index];
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

  WishlistTile(BuildContext context, WishList curwishList) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.grey)),
        child: Column(
          children: [
            Text(
              '#${curwishList.id}',
              style: TextStyles.bodySm,
            ),
            Text(
              '# ${curwishList.id}',
              style: TextStyles.body,
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
