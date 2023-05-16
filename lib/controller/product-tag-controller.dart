
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product/product.tag.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class ProductTagController extends GetxController {
  RxMap<String, List<ProductSummary>> tagsProductsList =
      <String, List<ProductSummary>>{}.obs;
  @override
  void onInit() {
    getTags();
    super.onInit();
  }

  getTags() async {
    var response =
        await ClientService.post(path: 'productTag/search', payload: {});
    if (response.statusCode == 200) {
      List<ProductTag> tagList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductTag.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);

      tagList.forEach((element) async {
        var responseProd = await ClientService.post(
            path: 'product/searchSummary', payload: {'tagId': element.id});
        if (responseProd.statusCode == 200) {
          List<ProductSummary> summaryProdList = ((responseProd.data
                      as List<dynamic>?)
                  ?.map(
                      (e) => ProductSummary.fromMap(e as Map<String, dynamic>))
                  .toList() ??
              []);

          tagsProductsList[
                  '${element.id}_${element.title!.defaultText != null ? element.title!.defaultText!.text : element.title!.languageTexts![0].text}'] =
              summaryProdList;
          tagsProductsList.refresh();
        }
      });
    }
  }
}
