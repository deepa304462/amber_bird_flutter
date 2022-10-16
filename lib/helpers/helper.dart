import 'dart:convert';

import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/utils/data-cache-service.dart';

class Helper {
  static Product conertToProductSummary() {
    print("1234");
    return new Product();
  }

  static Future<Ref> getCustomerRef() async {
    var data = jsonDecode(await SharedData.read('userData'));
    print(data);
    return Ref.fromMap(
        {'_id': data['mappedTo']['_id'], 'name': data['mappedTo']['name']});
  }
}
