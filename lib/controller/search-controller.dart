import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var search = ''.obs;
  RxList<Product> searchProductList = <Product>[].obs;

  setSearchVal(val) {
    search.value = (val);
  }

  getsearchData(query) async {
    var payload = {'keywords': query};
    var response = await ClientService.searchQuery(
        path: 'cache/product/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<Product> cList = ((response.data as List<dynamic>?)
              ?.map((e) => Product.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      searchProductList.value = (cList);

      // print(categoryList);
    }
  }
}
