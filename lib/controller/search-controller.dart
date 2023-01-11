import 'dart:convert';
import 'dart:developer';

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
  var popularItems = [].obs;

  @override
  void onInit() {
    super.onInit();
    getPopulrSearch();
  }

  setSearchVal(val) {
    search.value = (val);
  }

  getPopulrSearch() async {
    var payload = {"configId": "popularSearch", "providerId": "sbazar"};
    var resp =
        await ClientService.post(path: 'FieldMap/search', payload: payload);
    if (resp.statusCode == 200) {
      log(resp.data.toString());
      // items.value =[];
      List<Map<String, String>> arr = [];
      resp.data.forEach((elem) {
        var data = jsonDecode(elem['extraData']);
        arr.add({'label': data['label'], 'value': data['value']});
      });
      popularItems.value = arr; 
    }
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
