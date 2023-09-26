import 'package:amber_bird/controller/order-controller.dart';
import 'package:amber_bird/data/order/product_order.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/time-util.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../controller/cart-controller.dart';
import '../../controller/state-controller.dart';

class OrderDetailWidget extends StatelessWidget {
  late OrderController orderController;
  final CartController cartController =
  ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  List<ProductOrder>? products;
  List<ProductOrder>? msdProduct;
  List<ProductOrder>? scoinProduct;
  OrderDetailWidget(String orderId, {Key? key}) {
    orderController =
        ControllerGenerator.create(OrderController(), tag: orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => orderController.orderDetail.value.products != null
        ? ListView(

            children: [
              orderController.orderDetail.value.status == "CANCELLED"
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.cancel,
                                size: 60,
                                color: AppColors.primeColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 230,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Cancel: no action\nrequired",
                                        style: TextStyles.headingFont3),
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        "Ready to order? Top the Reorder\nbutton fill your cart with items you \nalready picker out.",
                                        style: TextStyles.titleFont,
                                        maxLines: 4,
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              _shippingDetails(context, orderController),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Item Info", style: TextStyles.headingFont),
              ),
              _orderProductSummary(context),
              _paymentDetails(context),
              orderController.orderDetail.value.status == "CANCELLED" ||
                      orderController.orderDetail.value.status == "DELIVERED"
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              cartController.reOrder(products, msdProduct, scoinProduct);
                            },
                            child: Text("Reorder"),
                          )
                        ],
                      ),
                    )
                  : SizedBox()
            ],
          )
        : SizedBox());
  }

  _orderProductSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: orderController.orderDetail.value.products!.map((e) {
          return Card(
            child: Column(
              children: [
                _orderProductTile(e, context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Divider(),
                      orderController.orderDetail.value.payment!.appliedCouponCode==null?SizedBox():     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Coupon", style: TextStyles.headingFont),
                               Text(
                              '${orderController.orderDetail.value.payment!.appliedCouponCode.toString()}${CodeHelp.euro}',
                              style: TextStyles.headingFont),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Taxes", style: TextStyles.headingFont),
                          Text(
                              '${orderController.orderDetail.value.payment!.appliedTaxAmount.toString()}${CodeHelp.euro}',
                              style: TextStyles.headingFont),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Shipping", style: TextStyles.headingFont),
                          Text("DHL", style: TextStyles.headingFont),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total", style: TextStyles.headingFont),
                          Text(
                              '${orderController.orderDetail.value.payment!.totalAmount!.toString()}${CodeHelp.euro}',
                              style: TextStyles.headingFont),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      orderController.orderDetail.value.payment!.totalSPointsEarned==null?SizedBox(): Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("s Points Applied",
                              style: TextStyles.headingFont),
                          Text(
                              '${orderController.orderDetail.value.payment!.totalSPointsEarned.toString()}${CodeHelp.euro}',
                              style: TextStyles.headingFont),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
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
            title: Column(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    e.product!.name!.defaultText!.text!,
                    style: TextStyles.titleFont,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    '${e.product!.varient!.weight!} ${CodeHelp.formatUnit(e.product!.varient!.unit!)}',
                    textAlign: TextAlign.start,
                    style: TextStyles.titleFont,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    '${e.product!.varient!.price!.offerPrice}${CodeHelp.euro} x ${e.count} Unit',
                    style: TextStyles.titleFont,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  '${e.price!.offerPrice}${CodeHelp.euro} ',
                  style: TextStyles.bodyFontBold,
                )
              ],
            ),
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
        ? Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Shipping Info",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      // height: ,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: orderController
                              .shippingDhl.value.shipments!.length,
                          itemBuilder: (_, index) {
                            var currentData =
                                orderController.shippingDhl.value.shipments![0];
                            var delTime = DateTime.parse(
                                currentData.estimatedTimeOfDelivery!);
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shipment method",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  // Text('Destination', style: TextStyles.bodyFontBold),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // const Text('Address'),
                                      Text(
                                          '${currentData.destination!.address!.countryCode!}${currentData.destination!.address!.addressLocality!}')
                                    ],
                                  ),
                                  // Text('Origin', style: TextStyles.bodyFontBold),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // const Text('Address'),
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
                                          DateTime time = DateTime.parse(
                                              currentEvent.timestamp!);
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Shipment method",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    currentEvent.description!,
                                                  ),
                                                  // Text('${currentEvent.timestamp}'),
                                                  Text(
                                                    '${TimeUtil.getFormatDateTime(time, 'dd MMM, yy')} ${TimeUtil.getFormatDateTime(time, 'hh:mm a')}',
                                                    style:
                                                        TextStyles.bodyFontBold,
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
                ),
              ),
            ],
          )
        : orderController.orderDetail.value.shipping!.destination != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shipping Address",
                        style: TextStyles.titleFont,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          orderController.orderDetail.value.shipping!
                                      .destination!.customerAddress!.name ==
                                  null
                              ? " "
                              : '${orderController.orderDetail.value.shipping!.destination!.customerAddress!.name}${" , "}',
                          style: TextStyles.bodyFontBold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            orderController.orderDetail.value.shipping!
                                        .destination!.customerAddress!.line1 ==
                                    null
                                ? " "
                                : '${orderController.orderDetail.value.shipping!.destination!.customerAddress!.line1}${" , "}',
                            style: TextStyles.titleFont,
                          ),
                          Text(
                            orderController
                                        .orderDetail
                                        .value
                                        .shipping!
                                        .destination!
                                        .customerAddress!
                                        .zipCode ==
                                    null
                                ? ""
                                : '${orderController.orderDetail.value.shipping!.destination!.customerAddress!.zipCode}',
                            style: TextStyles.titleFont,
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              )
            : const SizedBox();
  }

  _paymentDetails(BuildContext context) {
    DateTime orderTime =
        DateTime.parse(orderController.orderDetail.value.metaData!.createdAt!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Order Details", style: TextStyles.headingFont),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Number",
                        style: TextStyles.titleFont,
                      ),
                      Text(
                        orderController.orderDetail.value.userFriendlyOrderId
                            .toString(),
                        style: TextStyles.titleFont,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Total",
                        style: TextStyles.titleFont,
                      ),
                      Text(
                        '${orderController.orderDetail.value.payment!.totalAmount!.toString()}${CodeHelp.euro}',
                        style: TextStyles.titleFont,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Date",
                        style: TextStyles.titleFont,
                      ),
                      Text(
                        TimeUtil.getFormatDateTime(orderTime, 'dd MMM, yy'),
                        style: TextStyles.titleFont,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shipment Method",
                        style: TextStyles.titleFont,
                      ),
                      Text(
                        "DHL",
                        style: TextStyles.titleFont,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
