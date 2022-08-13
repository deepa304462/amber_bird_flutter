import 'package:get/get.dart';

class SearchController extends GetxController {
  var search = ''.obs;
  setSearchVal(val) {
    search.value = (val);
  }
}
