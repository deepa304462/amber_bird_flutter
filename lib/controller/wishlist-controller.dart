import 'package:amber_bird/data/wishlist-product.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  RxMap<String, WishlistProduct> wishlistProducts =
      Map<String, WishlistProduct>().obs;

  @override
  void onInit() {
    // initializeFirebase();
    super.onInit();
  }

  addToWishlist(pid, product) {
    WishlistProduct wishlistRow = WishlistProduct.fromMap(
        {'product': product.toMap(), 'isChecked': true});
    wishlistProducts[pid] = wishlistRow;
  }

  bool checkIfProductWishlist(pid) {
    if (pid != null) {
      WishlistProduct? wishlistRow = wishlistProducts[pid];
      if (wishlistRow != null) {
        return wishlistRow.isChecked!;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
