import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var search = ''.obs;
  RxList<ProductCategory> categoryList = <ProductCategory>[].obs; //RxList([]);
  RxList<ProductCategory> subCategoryList = <ProductCategory>[].obs;
  
  // increment() {
  //   count++;
  // }

  setCategory(cList){
    categoryList =RxList(cList);
  }
  setSubCategory(sList) {
    subCategoryList = RxList(sList);
  }

  setSearchVal(val){
    search = RxString(val);
  }
}
