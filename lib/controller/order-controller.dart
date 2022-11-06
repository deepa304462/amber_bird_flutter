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

<<<<<<< HEAD
   getOrder(String id) async {
     var response =
        await ClientService.get(path: 'order', id: id);
=======
  getOrder(String id) async {
    print(id);
    var response = await ClientService.get(path: 'order', id: id);
>>>>>>> 9ad39be4ef938592333e20eea16a1347a9937dfb
    if (response.statusCode == 200) {
      log(response.data.toString());
      orderDetail.value = Order.fromMap(response.data as Map<String, dynamic>);
    }
  }
}
