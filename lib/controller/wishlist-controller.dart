import 'dart:convert';

import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/customer/favorite.insight.detail.dart';
import 'package:amber_bird/data/customer/wish_list.insight.detail.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
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

      if (cust.wishList != null) {
        wishlistId.value = cust.wishList!.id ?? '';
      }
    } else {
      wishlistProducts.value = Map();
    }
  }

  addToWishlist(pid, product, products, type) async {
    if (pid != null) {
      Favorite? wishlistRowcheck = wishlistProducts[pid];
      if (wishlistRowcheck != null) {
        wishlistProducts.remove(pid);
      } else {
        Favorite fav = Favorite.fromMap({
          'product': product != null ? (jsonDecode(product.toJson())) : null,
          'products': products != null ? (jsonDecode(products.toJson())) : null,
          'productType': type,
          'ref': {'name': 'fav', '_id': pid},
          'addedOnTime': DateTime.now().toUtc().toString()
        });
        wishlistProducts[pid] = fav;
      }
      await saveWishlist();
    }
  }

  removeWishList(pid) async {
    wishlistProducts.remove(pid);
    await saveWishlist();
  }

  resetWishlist() async {
    wishlistProducts.clear();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    cust.wishList = null;
    await saveWishlist();
    OfflineDBService.save(
        OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
  }

  saveWishlist() async {
    List<dynamic> listProd = [];
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    for (var v in wishlistProducts.values) {
      listProd.add((jsonDecode(v.toJson())));
    }
    Ref custRef = await Helper.getCustomerRef();
    var payload, resp;
    if (wishlistId.value != '') {
      payload = {
        'customerRef': (jsonDecode(custRef.toJson())),
        'favorites': listProd,
        '_id': wishlistId.value,
        'metaData': (jsonDecode(cust.wishList!.metaData!.toJson())),
      };
      resp = await ClientService.Put(
          path: 'wishList', id: wishlistId.value, payload: payload);
    } else {
      payload = {
        'customerRef': (jsonDecode(custRef.toJson())),
        'favorites': listProd,
      };
      resp = await ClientService.post(path: 'wishList', payload: payload);
    }
    if (resp.statusCode == 200) {
      if (wishlistId.value == '') wishlistId.value = resp.data['_id'];
      cust.wishList = WishList.fromMap(resp.data);
      OfflineDBService.save(
          OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
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
