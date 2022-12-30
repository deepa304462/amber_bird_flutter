import 'dart:convert';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class Helper {
  static Product conertToProductSummary() {
    print("1234");
    return Product();
  }

  static Future<Ref> getCustomerRef() async {
    var data = jsonDecode(await SharedData.read('userData'));
    print(data);
    return Ref.fromMap(
        {'_id': data['mappedTo']['_id'], 'name': data['mappedTo']['name']});
  }

  static Future<dynamic> checkProductValidtoAddinCart(
      RuleConfig? ruleConfig, Constraint? constraint, String id) async {
    if (ruleConfig != null && ruleConfig.forWeekDays != null) {
      var insight =
          await OfflineDBService.get(OfflineDBService.customerInsight);
      CustomerInsight custInsight =
          CustomerInsight.fromJson(jsonEncode(insight));

      if (ruleConfig.forWeekDays!.length > 0) {
        DateTime date = DateTime.now();
        print("weekday is ${date.weekday}");
        if (!ruleConfig.forWeekDays!.contains(date.weekday)) {
          return ({'error': true, 'msg': 'Deal is not applicable today'});
        }
      }
      if (ruleConfig.minCartAmount != null && ruleConfig.minCartAmount != 0) {
        if (Get.isRegistered<CartController>()) {
          var cartController = Get.find<CartController>();
          if (cartController.calculatedPayment.value.totalAmount <
              ruleConfig.minCartAmount) {
            return ({
              'error': true,
              'msg': 'Required min cart amount ${ruleConfig!.minCartAmount}'
            });
          }
        }
      }

      if (ruleConfig.onlyForGoldenMember == true &&
          custInsight.membershipType != memberShipType.Gold.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Golden member'
        });
      }
      if (ruleConfig.onlyForPrimeMember == true &&
          custInsight.membershipType != memberShipType.Prime.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Prime member'
        });
      }
      if (ruleConfig.onlyForSilverMember == true &&
          custInsight.membershipType != memberShipType.Silver.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Silver member'
        });
      }
    }
    if (constraint!.maximumOrder != null && constraint!.maximumOrder != 0) {
      if (Get.isRegistered<CartController>()) {
        var cartController = Get.find<CartController>();
        if (cartController.cartProducts.value[id] != null) {
          var newCount = (cartController.cartProducts.value[id] == null
                  ? 0
                  : (cartController.cartProducts.value[id]!.count! ?? 0)) +
              (constraint!.minimumOrder == 0
                  ? 1
                  : int.parse(constraint!.minimumOrder.toString() ?? '0'));
          if ((constraint!.maximumOrder ?? 0) < newCount) {
            return ({
              'error': true,
              'msg': 'Max ${constraint!.maximumOrder} can be added!'
            });
          }
        }
      }
    }
    return ({'error': false, 'msg': ''});
  }
}
