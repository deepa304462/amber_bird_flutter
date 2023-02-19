import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailWidget extends StatelessWidget {
  final String? orderId;

  OrderDetailWidget(this.orderId, {Key? key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find(tag: orderId);
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Order Detail',
              style: TextStyles.titleXLargeBold,
            ),
            Obx(
              () {
                if (orderController.orderDetail.value.products != null) {
                  return Column(
                    children: [
                      Card(
                        elevation: 4, // Change this
                        shadowColor: Colors.black12, // Change this
                        child: Text(
                          'Order can be tracked by 000000000 Tracking link shared via message/mail ${orderController.orderDetail.value.shareLink != null ? orderController.orderDetail.value.shareLink!.name : ''}',
                          style: TextStyles.bodyFont,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4, // Change this
                        shadowColor: Colors.black12, // Change this
                        child: Column(
                          children: [
                            Text(
                                'Order Id #$orderId Status ${orderController.orderDetail.value.status}'),
                            Container(
                              margin: const EdgeInsets.all(2.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 113, 116, 122))),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: orderController
                                    .orderDetail.value.products!.length,
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  var currentProducts = orderController
                                      .orderDetail.value.products![index];
                                  if (currentProducts.products!.isNotEmpty) {
                                    return Container(
                                      // margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            currentProducts.products!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (_, index) {
                                          var currentProduct =
                                              currentProducts.products![index];
                                          return Row(
                                            children: [
                                              ImageBox(
                                                currentProduct.images![0],
                                                width: 80,
                                                height: 80,
                                              ),
                                              // Image.network(
                                              //     '${ClientService.cdnUrl}${currentProduct.images![0]}',
                                              //     width: 80,
                                              //     height: 80,
                                              //     fit: BoxFit.fill),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${currentProduct.name!.defaultText!.text}',
                                                style:
                                                    TextStyles.subHeadingFont,
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
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      child: Row(
                                        children: [
                                          ImageBox(
                                            currentProducts.product!.images![0],
                                            width: 80,
                                            height: 80,
                                          ),
                                          // Image.network(

                                          //     '${ClientService.cdnUrl}${currentProducts.product!.images![0]}',
                                          //     width: 80,
                                          //     height: 80,
                                          //     fit: BoxFit.fill),
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
                                      color: const
                                          Color.fromARGB(255, 113, 116, 122))),
                              child: Column(
                                children: orderController
                                            .orderDetail.value.shipping !=
                                        null
                                    ? [
                                        const Text('Shipping'),
                                        Text(orderController.orderDetail.value
                                                    .shipping!.source !=
                                                null
                                            ? 'Source ${orderController.orderDetail.value.shipping!.source!.customerAddress!.zipCode} ${orderController.orderDetail.value.shipping!.source!.customerAddress!.city}'
                                            : ''),
                                        Text(orderController.orderDetail.value
                                                    .shipping!.destination !=
                                                null
                                            ? 'Destination ${orderController.orderDetail.value.shipping!.destination!.customerAddress!.zipCode} ${orderController.orderDetail.value.shipping!.destination!.customerAddress!.city}'
                                            : ''),
                                        Text(orderController.orderDetail.value
                                                    .shipping!.lastMovement !=
                                                null
                                            ? 'Current Location ${orderController.orderDetail.value.shipping!.lastMovement!.locationName} ${orderController.orderDetail.value.shipping!.lastMovement!.time} ${orderController.orderDetail.value.shipping!.lastMovement!.status}'
                                            : ""),
                                        Text(
                                          'Status ${orderController.orderDetail.value.shipping!.finalStatus}',
                                          style: TextStyles.titleLargeBold,
                                        )
                                      ]
                                    : [
                                        const Text(
                                            'Shipping Information Not availbale'),
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ));
  }
}
