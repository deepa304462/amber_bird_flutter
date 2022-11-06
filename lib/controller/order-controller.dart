import 'dart:developer';

import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final tag;
  Rx<Order> orderDetail = Order().obs;

  OrderController(this.tag);
  @override
  void onInit() {
    super.onInit();
    getOrder(tag);
  }

  getOrder(String id) async {
    var response = await ClientService.get(path: 'order', id: id);
    if (response.statusCode == 200) {
      log(response.data.toString());
      orderDetail.value = Order.fromMap(response.data as Map<String, dynamic>);
    }
  }
}
