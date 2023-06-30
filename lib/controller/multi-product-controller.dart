import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class MultiProductController extends GetxController {
  RxList<Multi> multiProd = <Multi>[].obs;
  List months = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final tag;

  MultiProductController(this.tag);
  @override
  void onInit() {
    if (tag == multiProductName.COMBO.name) {
      getmultiProductProduct('COMBO');
    }
    if (tag == multiProductName.BUNDLE.name) {
      getmultiProductProduct('BUNDLE');
    }
    if (tag == multiProductName.COLLECTION.name) {
      getmultiProductProduct('COLLECTION');
    } else if (tag == dealName.SALES.name) {
      getmultiProductProduct('SALES');
    }

    super.onInit();
  }

  getmultiProductProduct(key) async {
    Controller stateController =
        ControllerGenerator.create(Controller(), tag: 'Controller');
    var payload = {"type": key};
    var response = await ClientService.searchQuery(
        path: 'cache/multiProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<Multi> dList = ((response.data as List<dynamic>?)?.map((e) {
            Multi dp = Multi.fromMap(e as Map<String, dynamic>);
            if (dp.products != null && dp.products!.length > 0) {
              dp.products!.forEach(
                  (e) => stateController.dealsProductsIdList.add(e.id ?? ''));
            }
            // stateController.dealsProductsIdList.add(dp.id ?? '');
            return dp;
          }).toList() ??
          []);
      stateController.dealsProductsIdList.value =
          stateController.dealsProductsIdList.toSet().toList();
      multiProd.value = (dList);
    }
  }

  getProductName(name) {
    if (multiProductName.COMBO.name == name) {
      return "Combos";
    } else if (multiProductName.BUNDLE.name == name) {
      return "Bundles";
    } else if (multiProductName.COLLECTION.name == name) {
      return "Collections";
    } else {
      return "Flash Deal";
    }
  }

  getMonth() {
    var now = new DateTime.now();
    return months[now.month - 1];
  }

  checkValidDeal(String id, String type, String cartId) async {
    RuleConfig? ruleConfig;
    Constraint? constraint;
    List outputList = multiProd.value.where((o) => o.id == id).toList();

    Multi multiProduct = outputList[0];
    ruleConfig = RuleConfig();
    constraint = multiProduct.constraint;

    // DealProduct();
    // var insight = await OfflineDBService.get(OfflineDBService.customerInsight);
    // CustomerInsight custInsight = CustomerInsight.fromJson(jsonEncode(insight));
    if (type == 'positive') {
      dynamic data = await Helper.checkProductValidtoAddinCart(
          ruleConfig, constraint, id, cartId);
      return data;
    } else {
      return ({'error': false, 'msg': ''});
    }
  }
}
