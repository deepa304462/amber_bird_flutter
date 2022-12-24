import 'dart:convert';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class DealController extends GetxController {
  RxList<DealProduct> dealProd = <DealProduct>[].obs;

  final tag;

  DealController(this.tag);
  @override
  void onInit() {
    if (tag == dealName.FLASH.name) {
      getDealProduct('FLASH');
    } else if (tag == dealName.SALES.name) {
      getDealProduct('SALES');
    }

    super.onInit();
  }

  String getDealName(name) {
    if (dealName.FLASH.name == name) {
      return "Flash Deal";
    } else if (dealName.SALES.name == name) {
      return "Sales Deal";
    } else {
      return "Flash Deal";
    }
  }

  getDealProduct(name) async {
    var payload = {"type": name};
    var response = await ClientService.searchQuery(
        path: 'dealProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<DealProduct> dList = ((response.data as List<dynamic>?)
              ?.map((e) => DealProduct.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      dealProd.value = (dList);
    }
  }

  checkValidDeal(String id) async {
    DealProduct dealProduct =
        dealProd.firstWhere((element) => element.id == id, orElse: () {
      return DealProduct();
    });
    // DealProduct();
    var insight = await OfflineDBService.get(OfflineDBService.customerInsight);
    CustomerInsight custInsight = CustomerInsight.fromJson(jsonEncode(insight));
    if (dealProduct.ruleConfig != null) {
      if (dealProduct.ruleConfig!.forWeekDays!.length > 0) {
        DateTime date = DateTime.now();
        print("weekday is ${date.weekday}");
        if (!dealProduct.ruleConfig!.forWeekDays!.contains(date.weekday)) {
          return ({'error': true, 'msg': 'Deal is not applicable today'});
        }
      }
      if (dealProduct.ruleConfig!.minCartAmount != null &&
          dealProduct.ruleConfig!.minCartAmount != 0) {
        if (Get.isRegistered<CartController>()) {
          var cartController = Get.find<CartController>();
          if (cartController.calculatedPayment.value.totalAmount <
              dealProduct.ruleConfig!.minCartAmount) {
            return ({
              'error': true,
              'msg':
                  'Required min cart amount ${dealProduct.ruleConfig!.minCartAmount}'
            });
          }
        }
      }
      if (dealProduct.constraint!.maximumOrder != null &&
          dealProduct.constraint!.maximumOrder != 0) {
        if (Get.isRegistered<CartController>()) {
          var cartController = Get.find<CartController>();
          if (cartController.cartProducts.value[id] != null) {
            var newCount = (cartController.cartProducts.value[id] == null
                    ? 0
                    : (cartController.cartProducts.value[id]!.count! ?? 0)) +
                (dealProduct.constraint!.minimumOrder == 0
                    ? 1
                    : int.parse(
                        dealProduct.constraint!.minimumOrder.toString() ??
                            '0'));
            if ((cartController.cartProducts.value[id]!.count ?? 0) <
                newCount) {
              return ({
                'error': true,
                'msg':
                    'Max ${dealProduct.constraint!.maximumOrder} can be added!'
              });
            }
          }
        }
      }
      if (dealProduct.ruleConfig!.onlyForGoldenMember == true &&
          custInsight.membershipType != memberShipType.Gold.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Golden member'
        });
      }
      if (dealProduct.ruleConfig!.onlyForPrimeMember == true &&
          custInsight.membershipType != memberShipType.Prime.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Prime member'
        });
      }
      if (dealProduct.ruleConfig!.onlyForSilverMember == true &&
          custInsight.membershipType != memberShipType.Silver.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Silver member'
        });
      }
    }

    // else {
    return ({'error': false, 'msg': ''});
    // }
  }
}
