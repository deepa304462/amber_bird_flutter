import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/solr_response/solr_response.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var search = ''.obs;
  Rx<SolrResponse> productResp = SolrResponse().obs;
  Rx<SolrResponse> categoryResp = SolrResponse().obs;
  Rx<SolrResponse> brandResp = SolrResponse().obs;
  Rx<bool> searchingProduct = true.obs;
  Rx<bool> searchingCategory = true.obs;
  Rx<bool> searchingBrand = true.obs;
  setSearchVal(val) {
    search.value = (val);
  }

  getsearchData(query) async {
    ClientService.solrSearch(path: 'product', queryData: query).then((value) {
      productResp.value = SolrResponse.fromMap(value.data);
      searchingProduct.value = false;
    });
    ClientService.solrSearch(path: 'category', queryData: query).then((value) {
      categoryResp.value = SolrResponse.fromMap(value.data);
      searchingCategory.value = false;
    });
    ClientService.solrSearch(path: 'brand', queryData: query).then((value) {
      brandResp.value = SolrResponse.fromMap(value.data);
      searchingBrand.value = false;
    });
  }
}
