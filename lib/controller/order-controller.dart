import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/data/dhl/dhl.shipping.dart';
import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Rx<Order> orderDetail = Order().obs;
  Rx<Dhl> shippingDhl = Dhl().obs;

  setOrderId(String givenOrderId) {
    getOrder(givenOrderId);
  }

  getOrder(String id) async {
    var response = await ClientService.get(path: 'order', id: id);
    if (response.statusCode == 200) {
      log(response.data.toString());
      orderDetail.value = Order.fromMap(response.data as Map<String, dynamic>);
      inspect(orderDetail.value);
      // if (orderDetail.value.shipping != null &&
      //     orderDetail.value.shipping!.dhlShipmentNumbers!.length > 0) {
        // Todo
        //  getShippingDhlData(orderDetail.value.shipping!.dhlShipmentNumbers![0]);
         getShippingDhlData("666666");

      // }
    }
  }

  getShippingDhlData(String dhlNumber) async {
    var response =
        await ClientService.get(path: 'shipping/tracking', id: dhlNumber);
    if (response.statusCode == 200) {
      print("response.data");
      print(response.data);
      print("response.data");
      shippingDhl.value =
          Dhl.fromMap(jsonDecode(response.data) as Map<String, dynamic>);
    }
  }
}
