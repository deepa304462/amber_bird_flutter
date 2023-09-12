import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class DealController extends GetxController {
  RxList<DealProduct> dealProd = <DealProduct>[].obs;
  RxBool isLoading = true.obs;

  final tag;

  DealController(this.tag);
  @override
  void onInit() {
    if (tag == dealName.FLASH.name) {
      getDealProduct('FLASH');
    } else if (tag == dealName.SALES.name) {
      getDealProduct('SALES');
    } else if (tag == dealName.WEEKLY_DEAL.name) {
      getDealProduct('WEEKLY_DEAL');
    } else if (tag == dealName.SUPER_DEAL.name) {
      getDealProduct('SUPER_DEAL');
    } else if (tag == dealName.ONLY_COIN_DEAL.name) {
      getDealProduct('ONLY_COIN_DEAL');
    } else if (tag == dealName.EXCLUSIVE_DEAL.name) {
      getDealProduct('EXCLUSIVE_DEAL');
    } else if (tag == dealName.MEMBER_DEAL.name) {
      getDealProduct('MEMBER_DEAL');
    } else if (tag == dealName.PRIME_MEMBER_DEAL.name) {
      getDealProduct('PRIME_MEMBER_DEAL');
    } else if (tag == dealName.CUSTOM_RULE_DEAL.name) {
      getDealProduct('CUSTOM_RULE_DEAL ');
    }

    super.onInit();
  }

  String getDealName(name) {
    if (dealName.FLASH.name == name) {
      return "Flash Deals";
    } else if (dealName.SALES.name == name) {
      return "Sales Deals";
    } else if (tag == dealName.WEEKLY_DEAL.name) {
      return 'Weekly Deals';
    } else if (tag == dealName.SUPER_DEAL.name) {
      return 'Super Deals';
    } else if (tag == dealName.ONLY_COIN_DEAL.name) {
      return 'Coin Deals';
    } else if (tag == dealName.EXCLUSIVE_DEAL.name) {
      return 'Exclusive Deals';
    } else if (tag == dealName.MEMBER_DEAL.name) {
      return 'Member Deals';
    } else if (tag == dealName.PRIME_MEMBER_DEAL.name) {
      return 'Prime Member Deals';
    } else if (tag == dealName.CUSTOM_RULE_DEAL.name) {
      return 'Custom Rule Deals';
    } else {
      return "Flash Deals";
    }
  }

  getDealProduct(name) async {
    Controller stateController =
        ControllerGenerator.create(Controller(), tag: 'Controller');
    var payload = {"type": name};
    var response = await ClientService.searchQuery(
        path: 'dealProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<DealProduct> dList = ((response.data as List<dynamic>?)?.map((e) {
            DealProduct dp = DealProduct.fromMap(e as Map<String, dynamic>);

            if (dp.product != null) {
              stateController.dealsProductsIdList.add(dp.product!.id ?? '');
              // dp.product!.varients!.forEach((e) => stateController.dealsProductsIdList.add(e ?? ''));
            }
            return dp;
          }).toList() ??
          []);
      stateController.dealsProductsIdList.value =
          stateController.dealsProductsIdList.toSet().toList();
      dealProd.value = (dList);
      isLoading.value = false;
    }
  }

  checkValidDeal(String id, String type, String cartId) async {
    RuleConfig? ruleConfig;
    Constraint? constraint;
    DealProduct dealProduct =
        dealProd.firstWhere((element) => element.id == id, orElse: () {
      return DealProduct();
    });
    ruleConfig = dealProduct.ruleConfig;
    constraint = dealProduct.constraint;
    if (type == 'positive') {
      dynamic data = await Helper.checkProductValidtoAddinCart(
          ruleConfig, constraint, id, cartId);
      return data;
    } else {
      return ({'error': false, 'msg': ''});
    }
  }
}
