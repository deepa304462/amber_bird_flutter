import 'dart:developer';

import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/time-util.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderListPage extends StatelessWidget {
  bool search = false;
  RxList<Order> orderList = <Order>[].obs;

  getOrderList() async {
    Ref custRef = await Helper.getCustomerRef();
    var response = await ClientService.post(
        path: 'order/search',
        payload: {"customerId": custRef.id, "onlyCart": false});
    if (response.statusCode == 200) {
      // log(response.data.toString());
      List<Order> oList = ((response.data as List<dynamic>?)
              ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      orderList.value = oList;
    }
  }

  @override
  Widget build(BuildContext context) {
    getOrderList();
    return Obx(() => Column(
          children: [
            AppBar(
              backgroundColor: AppColors.primeColor,
              title: Text(
                'Order List',
                style: TextStyles.headingFont.copyWith(color: Colors.white),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Modular.to.navigate('../home/main');
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            orderList.length > 0
                ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemCount: orderList.length,
                      itemBuilder: (_, index) {
                        var curOrder = orderList[index];
                        return OrderTile(context, curOrder);
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Lottie.asset('assets/no-data.json',
                              width: MediaQuery.of(context).size.width * .5,
                              fit: BoxFit.cover),
                          Expanded(
                            child: Text(
                              'No orders available, waiting for a new order.',
                              style: TextStyles.bodyFont,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ));
  }

  OrderTile(BuildContext context, Order curOrder) {
    print(curOrder.id);
    DateTime orderTime = DateTime.parse(curOrder!.metaData!.createdAt!);
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${TimeUtil.getFormatDateTime(orderTime, 'dd MMM, yy')}',
                  style: TextStyles.bodyFontBold,
                ),
                Text(
                  '${TimeUtil.getFormatDateTime(orderTime, 'hh:mm a')}',
                  style: TextStyles.bodyFont.copyWith(fontSize: 15),
                ),
              ],
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Order #'),
                    Text(
                      '${curOrder.userFriendlyOrderId}',
                      style: TextStyles.title.copyWith(
                          color: AppColors.primeColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                    '${curOrder.products!.length} ${curOrder.products!.length > 1 ? 'products' : 'product'} ordered'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Order Status', style: TextStyles.bodyFont),
                Text('${curOrder.status}', style: TextStyles.bodyFontBold),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                        '${CodeHelp.euro}${curOrder.payment!.totalAmount!.toString()} ',
                        style: TextStyles.bodyFontBold
                            .copyWith(color: Colors.green)),
                    Text(
                      'Paid',
                      style:
                          TextStyles.bodyFontBold.copyWith(color: Colors.grey),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Order will be deliver soon.',
                      style:
                          TextStyles.bodyFontBold.copyWith(color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: () {
                          Modular.to.navigate('/home/order-detail',
                              arguments: {'id': curOrder.id});
                        },
                        child: Text(
                          'View details',
                          style: TextStyles.bodyFontBold
                              .copyWith(color: AppColors.primeColor),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
