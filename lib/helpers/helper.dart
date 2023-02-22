import 'dart:convert';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class Helper {
  static Product conertToProductSummary() {
    return Product();
  }

  static double getFormattedNumber(num) {
    if (num != null) {
      return double.parse((num).toStringAsFixed(2));
    } else
      return 0;
  }

  static dynamic getMemberCoinValue(Price price,String userType) {
    if (userType == memberShipType.Paid.name) {
      return price.paidMemberCoin;
    } else if (userType == memberShipType.Platinum.name) {
      return price.platinumMemberCoin;
    } else if (userType == memberShipType.Gold.name) {
      return price.goldMemberCoin;
    } else if (userType == memberShipType.Silver.name) {
      return price.silverMemberCoin;
    } else {
      return price.noMemberCoin;
    }
  }
  static Future<Ref> getCustomerRef() async {
    var data = jsonDecode(await SharedData.read('userData'));
    print(data);
    return Ref.fromMap(
        {'_id': data['mappedTo']['_id'], 'name': data['mappedTo']['name']});
  }

  static Future<dynamic> checkProductValidtoAddinCart(RuleConfig? ruleConfig,
      Constraint? constraint, String id, String cartId) async {
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
              'msg': 'Required min cart amount ${ruleConfig.minCartAmount}'
            });
          }
        }
      }

      if (ruleConfig.onlyForGoldMember == true &&
          custInsight.membershipType != memberShipType.Gold.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Golden member'
        });
      }
      if (ruleConfig.onlyForPlatinumMember == true &&
          custInsight.membershipType != memberShipType.Platinum.name) {
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
    if (constraint != null &&
        constraint.maximumOrder != null &&
        constraint.maximumOrder != 0) {
      if (Get.isRegistered<CartController>()) {
        var cartController = Get.find<CartController>();
        if (cartController.cartProducts.value[cartId] != null) {
          var newCount = (cartController.cartProducts.value[cartId] == null
                  ? 0
                  : (cartController.cartProducts.value[cartId]!.count! ?? 0)) +
              (constraint.minimumOrder == 0
                  ? 1
                  : int.parse(constraint.minimumOrder.toString() ?? '0'));
          if ((constraint.maximumOrder ?? 0) < newCount) {
            return ({
              'error': true,
              'msg': 'Max ${constraint.maximumOrder} can be added!'
            });
          }
        }
      }
    }
    return ({'error': false, 'msg': ''});
  }
}
