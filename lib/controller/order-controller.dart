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
      if (orderDetail.value.shipping != null &&
          orderDetail.value.shipping!.dhlShipmentNumber != null) {
        getShippingDhlData(orderDetail.value.shipping!.dhlShipmentNumber!);
      }
    }
  }

  getShippingDhlData(String dhlNumber) async {
    print(dhlNumber);

    var response =
        await ClientService.get(path: 'shipping/tracking', id: dhlNumber);
    if (response.statusCode == 200) {
      // log(response.data.toString());
      // orderDetail.value = Order.fromMap(response.data as Map<String, dynamic>);
      inspect(response.data);
      shippingDhl.value =
          Dhl.fromMap(jsonDecode(response.data) as Map<String, dynamic>);
      inspect(shippingDhl.value);
      print(shippingDhl.value);
      // response.data;
      // if (orderDetail.value.shipping != null &&
      //     orderDetail.value.shipping!.dhlShipmentNumber != null) {
      //   getShippingDhlData(orderDetail.value.shipping!.dhlShipmentNumber!);
      // }
    }
  }
}
