import 'dart:developer';

import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class OrderListPage extends StatelessWidget {
  bool search = false;
  RxList<Order> orderList = <Order>[].obs;

  getOrderList() async {
    var response = await ClientService.get(path: 'order');
    if (response.statusCode == 200) {
      log(response.data.toString());
      List<Order> oList = ((response.data as List<dynamic>?)
              ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      orderList.value = oList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () {
                  Modular.to.navigate('../home/main');
                },
                icon: const Icon(Icons.arrow_back))
          ]),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [],
            ),
          ),
        ]),
      ),
    );
  }
}

 