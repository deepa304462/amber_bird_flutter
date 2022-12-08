import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/customer/favorite.insight.detail.dart';
import 'package:amber_bird/data/customer/wish_list.insight.detail.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/data/wishlist-product.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  RxMap<String, Favorite> wishlistProducts = <String, Favorite>{}.obs;
  RxString wishlistId = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  fetchWishlist() async {
    var insightDetailloc =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (insightDetailloc != null) {
      Customer cust = Customer.fromMap(
          (jsonDecode(jsonEncode(insightDetailloc))) as Map<String, dynamic>);
      log(cust.toString());
      if (cust.wishList != null) {
        wishlistId.value = cust.wishList!.id ?? '';
        for (var element in cust.wishList!.favorites!) {
          wishlistProducts[element.ref!.id ?? ''] = element;
        }
        // totalPrice.value = pr;
      }
    } else {
      wishlistProducts.value = Map();
    }
  }

  addToWishlist(pid, product, products,type) async{
    if (pid != null) {
      Favorite? wishlistRowcheck = wishlistProducts[pid];
      if (wishlistRowcheck != null) {
        wishlistProducts.remove(pid);
      } else {
        // WishlistProduct wishlistRow = WishlistProduct.fromMap(
        //     {'product': product.toMap(), 'isChecked': true});
        // wishlistProducts[pid] = wishlistRow;
        Ref custRef = await Helper.getCustomerRef();
        Favorite fav =Favorite.fromMap({
          'product': product,
          'products': products,
          'productType': type,
          'ref':custRef,
          'addedOnTime': DateTime.now().toUtc()
        });
         wishlistProducts[pid] = fav;

      }
    }
  }

  bool checkIfProductWishlist(pid) {
    if (pid != null) {
      Favorite? wishlistRow = wishlistProducts[pid];
      if (wishlistRow != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
