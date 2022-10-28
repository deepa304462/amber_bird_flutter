import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailWidget extends StatelessWidget {
  final String? orderId;

  OrderDetailWidget(this.orderId, {Key? key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find(tag: orderId);
    return Obx(() {
      if (orderController.orderDetail.value.products != null) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Card(
              elevation: 4, // Change this
              shadowColor: Colors.black12, // Change this
              child: Text(
                'Order can be tracked by 000000000 Tracking link shared via message/mail',
                style: TextStyles.bodyFont,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4, // Change this
              shadowColor: Colors.black12, // Change this
              child: Column(
                children: [
                  Text('Order Id #${orderId}'),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 113, 116, 122))),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:
                          orderController.orderDetail.value.products!.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        var currentProducts =
                            orderController.orderDetail.value.products![index];
                        if (currentProducts.products!.isNotEmpty) {
                          return Container(
                            // margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent)),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: currentProducts.products!.length,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                var currentProduct =
                                    currentProducts.products![index];
                                return Row(
                                  children: [
                                    Image.network(
                                        '${ClientService.cdnUrl}${currentProduct.images![0]}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.fill),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${currentProduct.name!.defaultText!.text}',
                                      style: TextStyles.subHeadingFont,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            // margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent)),
                            child: Row(
                              children: [
                                Image.network(
                                    '${ClientService.cdnUrl}${currentProducts.product!.images![0]}',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fill),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${currentProducts.product!.name!.defaultText!.text}',
                                  style: TextStyles.subHeadingFont,
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 113, 116, 122))),
                      child: Column(
                        children: [
                          Text('Shipping'),
                        ],
                      ))
                ],
              ),
            ),
          ]),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
