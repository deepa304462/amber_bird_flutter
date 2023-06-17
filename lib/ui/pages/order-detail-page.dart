import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/order-detail-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../widget/loading-with-logo.dart';

class OrderDetailPage extends StatelessWidget {
  final String navigateTo;
  bool search = false;
  late OrderController orderController;
  OrderDetailPage(
    String orderId,
    this.navigateTo, {
    Key? key,
    required bool search,
  }) {
    orderController =
        ControllerGenerator.create(OrderController(), tag: orderId);
    orderController.setOrderId(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        title: Text(
          'Order Detail',
          style: TextStyles.bodyFont.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            if (navigateTo == 'HOME') {
              Modular.to.navigate('../home/main');
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
                child: orderController.orderDetail.value.id != null
                    ? OrderDetailWidget(orderController.orderDetail.value.id!)
                    : const LoadingWithLogo())
          ],
        ),
      ),
    );
  }
}
