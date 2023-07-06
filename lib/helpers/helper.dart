import 'dart:convert';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/price/price.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';
import 'controller-generator.dart';

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

  static String formatNumberTwodigit(num) {
    if (num != null) {
      return ((num).toString().padLeft(5, '0'));
    } else
      return '0';
  }

  static double getMsdAmount({required Price price, required String userType}) {
    if (userType == memberShipType.Paid.name) {
      return price.membersSpecialPrice!.forGoldMember!;
    } else if (userType == memberShipType.Platinum.name) {
      return price.membersSpecialPrice!.forPlatinumMember!;
    } else if (userType == memberShipType.Gold.name) {
      return price.membersSpecialPrice!.forGoldMember!;
    } else if (userType == memberShipType.Silver.name) {
      return price.membersSpecialPrice!.forSilverMember!;
    } else {
      return price.membersSpecialPrice!.forGoldMember!;
    }
  }

  static double getShipping() {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      if (controller.membershipList[controller.userType.value] != null) {
        return controller
            .membershipList[controller.userType.value]!.standardShippingCharge!;
      } else {
        return 4.99;
      }
    } else {
      return 4.99;
    }
  }

  static dynamic getOfferedShipping() async {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      var insightDetail =
          await OfflineDBService.get(OfflineDBService.customerInsightDetail);

      Customer cust = Customer();
      if (insightDetail != null) {
        cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
      }
      if (controller.membershipList[controller.userType.value] != null &&
          cust.cart != null &&
          cust.cart!.payment != null) {
        return {
          'amountRequired': controller
                  .membershipList[controller.userType.value]!
                  .cartValueAboveWhichOfferShippingApplied! -
              (cust.cart!.payment!.totalAmount -
                  cust.cart!.payment!.shippingAmount),
          'offeredShipping': controller
              .membershipList[controller.userType.value]!.offerShippingCharge!
        };
      } else if (controller.membershipList[controller.userType.value] != null &&
          cust.cart != null &&
          cust.cart!.payment == null) {
        return {
          'amountRequired': controller
              .membershipList[controller.userType.value]!
              .cartValueAboveWhichOfferShippingApplied!,
          'offeredShipping': controller
              .membershipList[controller.userType.value]!.offerShippingCharge!
        };
      } else {
        return {
          'amountRequired': controller
              .membershipList[memberShipType.No_Membership.name]!
              .cartValueAboveWhichOfferShippingApplied!,
          'offeredShipping': controller
              .membershipList[memberShipType.No_Membership.name]!
              .offerShippingCharge!
        };
      }
    }
    return {'amountRequired': 0, 'offeredShipping': 4.99};
  }

  static dynamic getCatMultiName(String dealType) {
    if (dealType == multiProductName.COMBO.name) {
      return {
        'name': 'Combos',
        'imageId': '441a4502-d2a0-44fc-9ade-56af13a2f7f0'
      };
    } else if (dealType == multiProductName.BUNDLE.name) {
      return {
        'name': 'Bundles',
        'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'
      };
    } else if (dealType == multiProductName.COLLECTION.name) {
      return {
        'name': 'Jumbos',
        'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'
      };
    } else {
      return {'name': 'Hot', 'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'};
    }
  }

  static dynamic getCatDealName(String dealType) {
    if (dealType == dealName.SALES.name) {
      return {
        'name': 'Sales',
        'imageId': '441a4502-d2a0-44fc-9ade-56af13a2f7f0'
      };
    } else if (dealType == dealName.FLASH.name) {
      return {
        'name': 'Flash',
        'imageId': '34038fcf-20e1-4840-a188-413b83d72e11'
      };
    } else if (dealType == dealName.SUPER_DEAL.name) {
      return {'name': 'Hot', 'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'};
    } else if (dealType == dealName.WEEKLY_DEAL.name) {
      return {
        'name': 'Weekly',
        'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'
      };
    } else if (dealType == dealName.MEMBER_DEAL.name) {
      return {
        'name': 'Member',
        'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'
      };
    } else if (dealType == dealName.ONLY_COIN_DEAL.name) {
      return {
        'name': 'COIN',
        'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'
      };
    } else if (dealType == dealName.PRIME_MEMBER_DEAL.name) {
      return {
        'name': 'Prime',
        'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'
      };
    } else {
      return {'name': 'Hot', 'imageId': '993a345c-885b-423b-bb49-f4f1c6ba78d0'};
    }
  }

  static dynamic getMemberCoinValue(Price price, String userType) {
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

  static String formatStringPurpose(String val) {
    var data = val.split('_');
    print(data);
    return data.join(' ');
  }

  static Future<Ref> getCustomerRef() async {
    var data = jsonDecode((await SharedData.read('userData')) ?? '{}');
    print(data);
    return Ref.fromMap(
        {'_id': data['mappedTo']['_id'], 'name': data['mappedTo']['name']});
  }

  static dynamic checkValidScoin(
      Price price, String userType, scoinProduct, userTotalCoin, count) {
    var priceTotalToPay = getMemberCoinValue(price, userType);
    if (count > 1) {
      priceTotalToPay = priceTotalToPay * count;
    }
    if (priceTotalToPay > userTotalCoin) {
      return ({
        'error': true,
        'msg': 'Insufficient Coins in wallet',
        'type': ''
      });
    }
    var totalscoinInart = 0;
    if (scoinProduct.length > 0) {
      scoinProduct.forEach((key, elem) {
        var val = getMemberCoinValue(elem.price, userType);
        totalscoinInart += val as int;
      });
    }

    if (priceTotalToPay > (userTotalCoin - totalscoinInart)) {
      return ({
        'error': true,
        'msg': 'Insufficient Coins in wallet',
        'type': ''
      });
    }
    return ({'error': false, 'msg': '', 'type': ''});
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
        if (!ruleConfig.forWeekDays!.contains(date.weekday)) {
          return ({
            'error': true,
            'msg': 'Deal is not applicable today',
            'type': ''
          });
        }
      }
      if (ruleConfig.minCartAmount != null && ruleConfig.minCartAmount != 0) {
        var cartController =
            ControllerGenerator.create(CartController(), tag: 'cartController');
        if (cartController.calculatedPayment.value.totalAmount <
            ruleConfig.minCartAmount) {
          return ({
            'error': true,
            'msg': 'Required min cart amount ${ruleConfig.minCartAmount}'
          });
        }
      }

      if (ruleConfig.onlyForGoldMember == true &&
          custInsight.membershipType != memberShipType.Gold.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Golden member',
          'type': ''
        });
      }
      if (ruleConfig.onlyForPlatinumMember == true &&
          custInsight.membershipType != memberShipType.Platinum.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Prime member',
          'type': ''
        });
      }
      if (ruleConfig.onlyForSilverMember == true &&
          custInsight.membershipType != memberShipType.Silver.name) {
        return ({
          'error': true,
          'msg': 'Deal is applicable for only Silver member',
          'type': ''
        });
      }
    }
    if (constraint != null &&
        constraint.maximumOrder != null &&
        constraint.maximumOrder != 0) {
      var cartController =
          ControllerGenerator.create(CartController(), tag: 'cartController');
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
            'msg': 'Max ${constraint.maximumOrder} can be added!',
            'type': 'maxNumberExceeded'
          });
        }
      }
    }
    return ({'error': false, 'msg': '', 'type': ''});
  }
}
