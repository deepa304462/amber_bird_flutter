import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/data/order/product_order.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/time-util.dart';
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
    return Obx(() => orderController.orderDetail.value.products != null
        ? ListView(
            children: [
              _orderProductSummary(context),
              _shippingDetails(context, orderController),
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
                  '${e.product!.varient!.price!.offerPrice}${CodeHelp.euro} x ${e.count} Unit',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${e.price!.offerPrice}${CodeHelp.euro} ',
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
                  '${e.price!.offerPrice}${CodeHelp.euro} x ${e.count} Unit',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${e.price!.offerPrice}${CodeHelp.euro} ',
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

  Widget _shippingDetails(
      BuildContext context, OrderController orderController) {
    return orderController.shippingDhl.value.shipments != null &&
            orderController.shippingDhl.value.shipments!.length > 0
        ? Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                // height: ,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount:
                        orderController.shippingDhl.value.shipments!.length,
                    itemBuilder: (_, index) {
                      var currentData =
                          orderController.shippingDhl.value.shipments![0];
                      var delTime =
                          DateTime.parse(currentData.estimatedTimeOfDelivery!);
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  currentData.status!.description!,
                                  style: TextStyles.headingFont
                                      .copyWith(color: Colors.blue),
                                ),
                                Text(
                                  '${TimeUtil.getFormatDateTime(delTime, 'dd MMM, yy')} ${TimeUtil.getFormatDateTime(delTime, 'hh:mm a')}',
                                  style: TextStyles.bodyFontBold,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Destination', style: TextStyles.bodyFontBold),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Address'),
                                Text(
                                    '${currentData.destination!.address!.countryCode!}${currentData.destination!.address!.addressLocality!}')
                              ],
                            ),
                            Text('Origin', style: TextStyles.bodyFontBold),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Address'),
                                Text(
                                    '${currentData.origin!.address!.countryCode!}${currentData.origin!.address!.addressLocality!}')
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // const Text('Origin'),
                            SizedBox(
                              height: 200,
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: currentData.events!.length,
                                  itemBuilder: (_, index) {
                                    var currentEvent =
                                        currentData.events![index];
                                    DateTime time =
                                        DateTime.parse(currentEvent.timestamp!);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(currentEvent.description!),
                                            // Text('${currentEvent.timestamp}'),
                                            Text(
                                              '${TimeUtil.getFormatDateTime(time, 'dd MMM, yy')} ${TimeUtil.getFormatDateTime(time, 'hh:mm a')}',
                                              style: TextStyles.bodyFontBold,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          currentEvent.location!.address!
                                              .addressLocality!,
                                          style: TextStyles.body,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          ]);
                    }),
              ),
            ),
          )
        : const SizedBox();
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
                  '${orderController.orderDetail.value.payment!.appliedTaxAmount!.toString()}${CodeHelp.euro}',
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
                  '${orderController.orderDetail.value.payment!.discountAmount!.toString()}${CodeHelp.euro}',
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
                  '${orderController.orderDetail.value.payment!.totalAmount!.toString()}${CodeHelp.euro}',
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
