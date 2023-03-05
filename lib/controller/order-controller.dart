import 'dart:developer';

import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Rx<Order> orderDetail = Order().obs;

  setOrderId(String givenOrderId) {
    getOrder(givenOrderId);
  }

  getOrder(String id) async {
    var response = await ClientService.get(path: 'order', id: id);
    if (response.statusCode == 200) {
      // log(response.data.toString());
      orderDetail.value = Order.fromMap(response.data as Map<String, dynamic>);
    }
  }
}
