import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/data/order/product_order.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailWidget extends StatelessWidget {
  late OrderController orderController;

  OrderDetailWidget(String orderId, {Key? key}) {
    orderController =
        ControllerGenerator.create(OrderController(), tag: orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => orderController.orderDetail != null &&
            orderController.orderDetail.value.products != null
        ? ListView(
            children: [
              _orderProductSummary(context),
              _shippingDetails(context),
              _paymentDetails(context)
            ],
          )
        : const SizedBox());
  }

  _orderProductSummary(BuildContext context) {
    return Column(
      children: orderController.orderDetail.value.products!
          .map((e) => Card(child: _orderProductTile(e, context)))
          .toList(),
    );
  }

  Widget _orderProductTile(ProductOrder e, BuildContext context) {
    return e.products!.length == 0
        ? ListTile(
            dense: false,
            leading: ImageBox(
              e.product!.images![0],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text(
              e.product!.name!.defaultText!.text!,
              style: TextStyles.bodyFontBold,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${CodeHelp.euro}${e.product!.varient!.price!.offerPrice} x ${e.count} Unit',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${CodeHelp.euro}${e.price!.offerPrice} ',
                  style: TextStyles.bodyFontBold,
                )
              ],
            ),
            subtitle: Text(
                '${e.product!.varient!.weight!} ${CodeHelp.formatUnit(e.product!.varient!.unit!)}'),
          )
        : ListTile(
            dense: false,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${CodeHelp.euro}${e.price!.offerPrice} x ${e.count} Unit',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${CodeHelp.euro}${e.price!.offerPrice} ',
                  style: TextStyles.bodyFontBold,
                )
              ],
            ),
            title: Column(
              children: e.products!
                  .map((multiProduct) => ListTile(
                        dense: false,
                        leading: ImageBox(
                          multiProduct.images![0],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          '${multiProduct.name!.defaultText!.text}',
                          style: TextStyles.bodyFontBold,
                        ),
                        subtitle: Text(
                            '${multiProduct.varient!.weight!} ${CodeHelp.formatUnit(multiProduct.varient!.unit!)}'),
                      ))
                  .toList(),
            ),
          );
  }

  Widget _shippingDetails(BuildContext context) {
    return Column(
      children: [],
    );
  }

  _paymentDetails(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total tax paid',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${CodeHelp.euro}${orderController.orderDetail.value.payment!.appliedTaxAmount!.toString()}',
                  style: TextStyles.bodyFontBold,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount amount',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${CodeHelp.euro}${orderController.orderDetail.value.payment!.discountAmount!.toString()}',
                  style: TextStyles.bodyFontBold,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total amount paid',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${CodeHelp.euro}${orderController.orderDetail.value.payment!.totalAmount!.toString()}',
                  style: TextStyles.bodyFontBold,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
