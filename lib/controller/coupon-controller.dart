import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/data/coupon_code/coupon_code.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class CouponController extends GetxController {
  var search = ''.obs;
  RxList<CouponCode> searchCouponList = <CouponCode>[].obs;
  Rx<bool> searchingProduct = true.obs;

  setSearchVal(val) {
    search.value = (val);
  }

  getsearchData(query) async {
    var payload = {'keywords': query};
    var response =
        await ClientService.post(path: 'couponCode/search', payload: payload);

    if (response.statusCode == 200) {
      List<CouponCode> cList = ((response.data as List<dynamic>?)
              ?.map((e) => CouponCode.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      searchCouponList.value = (cList);

      // print(categoryList);
    }
  }

  isApplicableCoupun(CouponCode coupon) {
    bool valid = true;
    if (Get.isRegistered<CartController>()) {
      var cartController = Get.find<CartController>();
      if (coupon.condition!.expireAtTime != null) {
        valid = false;
      } else if (coupon.condition!.maxCartAmount != null) {
        if (cartController.totalPrice.value.offerPrice <=
            coupon.condition!.maxCartAmount) {
          valid = false;
        }
      }
    }
    return valid;
  }
}
