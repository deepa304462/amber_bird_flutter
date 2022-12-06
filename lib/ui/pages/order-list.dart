import 'dart:developer';

import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class OrderListPage extends StatelessWidget {
  bool search = false;
  RxList<Order> orderList = <Order>[].obs;

  getOrderList() async {
    Ref custRef = await Helper.getCustomerRef();
    var response = await ClientService.post(path: 'order/search',payload: {"customerId":custRef.id});
    if (response.statusCode == 200) {
      log(response.data.toString());
      List<Order> oList = ((response.data as List<dynamic>?)
              ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      orderList.value = oList;
    }
    //  var insightDetail =
    //     await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    // log(insightDetail.toString());
    // Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    // orderList.value = cust.orders;
  }

  @override
  Widget build(BuildContext context) {
    getOrderList();
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            IconButton(
                onPressed: () {
                  Modular.to.navigate('../home/main');
                },
                icon: const Icon(Icons.arrow_back)),
            Text(
              'Order List',
              style: TextStyles.headingFont,
            )
          ]),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(5),
            ),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .70),
            padding: const EdgeInsets.all(8.0),
            child: orderList.length > 0
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: orderList.length,
                    itemBuilder: (_, index) {
                      var curOrder = orderList[index];
                      return Text(curOrder.id ?? '');
                    },
                  )
                : Center(child: Text('No Orders Available',style: TextStyles.body,)),
          ),
        ]),
      ),
    );
  }
}
