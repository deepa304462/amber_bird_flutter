import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/ui/pages/product_detail_screen.dart';
import 'package:amber_bird/ui/widget/order-detail-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  bool search = false;
  OrderDetailPage(
    this.orderId, {
    Key? key,
    required bool search,
  });

  @override
  Widget build(BuildContext context) {
    final OrderController orderController =
        Get.put(OrderController(orderId), tag: orderId);
    print(orderId);
    return OrderDetailWidget(orderId);
  }
}
