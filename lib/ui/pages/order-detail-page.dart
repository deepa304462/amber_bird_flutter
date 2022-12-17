import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/ui/widget/order-detail-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  final String navigateTo;
  bool search = false;
  OrderDetailPage(
    this.orderId,
    this.navigateTo, {
    Key? key,
    required bool search,
  });

  @override
  Widget build(BuildContext context) {
    final OrderController orderController =
        Get.put(OrderController(orderId), tag: orderId);
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
            onPressed: () {
              if (navigateTo == 'HOME') {
                Modular.to.navigate('../home/main');
              } else {
                Modular.to.navigate('../home/orders');
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          Text(
            'Order Detail',
            style: TextStyles.headingFont,
          )
        ]),
        OrderDetailWidget(orderId)
      ],
    );
  }
}
