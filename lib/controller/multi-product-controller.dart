import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class MultiProductController extends GetxController {
  RxList<Multi> multiProd = <Multi>[].obs;

  final tag;

  MultiProductController(this.tag);
  @override
  void onInit() {
    if (tag == multiProductName.COMBO) {
      getmultiProductProduct('COMBO');
    }
    if (tag == multiProductName.BUNDLE) {
      getmultiProductProduct('BUNDLE');
    }
    if (tag == multiProductName.COLLECTION) {
      getmultiProductProduct('COLLECTION');
    } else if (tag == dealName.SALES) {
      getmultiProductProduct('SALES');
    }

    super.onInit();
  }

  getmultiProductProduct(key) async {
    var payload = {"type": key};
    var response = await ClientService.searchQuery(
        path: 'cache/multiProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<Multi> dList = ((response.data as List<dynamic>?)
              ?.map((e) => Multi.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      multiProd.value = (dList);
    }
  }

  getProductName(name) {
    if (multiProductName.COMBO == name) {
      return "Combo Deal";
    } else if (multiProductName.BUNDLE == name) {
      return "Bundle Deal";
    } else if (multiProductName.COLLECTION == name) {
      return "Collections";
    } else {
      return "Flash Deal";
    }
  }
}
