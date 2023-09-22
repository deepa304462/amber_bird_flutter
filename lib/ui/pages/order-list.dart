import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/data/order/product_order.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../widget/compilance-widget.dart';
import '../widget/loading-with-logo.dart';

class OrderListPage extends StatelessWidget {
  RxBool isLoading = true.obs;
  RxList<Order> orderList = <Order>[].obs;

  getOrderList() async {
    isLoading.value = true;
    Ref custRef = await Helper.getCustomerRef();
    var response = await ClientService.post(
        path: 'order/search',
        payload: {"customerId": custRef.id, "onlyOrders": true});
    if (response.statusCode == 200) {
      List<Order> oList = ((response.data as List<dynamic>?)
              ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      isLoading.value = false;
      orderList.value = oList;
    }
  }

  @override
  Widget build(BuildContext context) {
    getOrderList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        leading: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 15,
          ),
        ),
        title: Column(
          children: [
            Text(
              'My Orders',
              style: TextStyles.bodyFont.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            isLoading.value
                ? const Expanded(child: LoadingWithLogo())
                : orderList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemCount: orderList.length,
                          itemBuilder: (_, index) {
                            var curOrder = orderList[index];
                            return OrdeTile(context, curOrder);
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
        ),
      ),
    );
  }

  Widget orderButtons(Order curOrder, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Visibility(
            visible: checkValidMissingReq(curOrder),
            child: Expanded(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Missing',
                  style: TextStyles.headingFont.copyWith(color: AppColors.grey),
                ),
              ),
            ),
          ),
          Visibility(
            visible: checkValidCancelReq(curOrder),
            child: Expanded(
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isDismissible: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    elevation: 3,
                    builder: (context) {
                      bool _isChecked = false;
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * .75,
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .6,
                                  child:
                                      CompilanceWidget('CANCELLATION_POLICY')),
                              StatefulBuilder(
                                builder: (BuildContext context, state) =>
                                    Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CheckboxListTile(
                                      title: Text(
                                        'I have read and agree with the above Term and condition',
                                        style: TextStyles.titleFont,
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: AppColors.primeColor,
                                      // checkColor: Colors.yellow,
                                      selected: _isChecked,
                                      value: _isChecked,
                                      onChanged: (value) {
                                        state(() {
                                          _isChecked = value!;
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          OutlinedButton(
                                            child: Text("Cancel"),
                                            style: OutlinedButton.styleFrom(
                                              // primary: Colors.red,
                                              side: BorderSide(
                                                width: 2,
                                                color: Colors.red,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          ElevatedButton(
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(
                                                  fontFamily: Fonts.body,
                                                  fontSize: FontSizes.title,
                                                  color: AppColors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _isChecked
                                                  ? AppColors.primeColor
                                                  : AppColors.grey,
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              if (_isChecked) {
                                                Navigator.of(context).pop();

                                                _showCancelOrderConfirmationDialog(
                                                    context,
                                                    curOrder
                                                        .userFriendlyOrderId!);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  );
                },
                child: Text(
                  'Cancel',
                  style: TextStyles.headingFont.copyWith(color: AppColors.grey),
                ),
              ),
            ),
          ),
          Visibility(
            visible: checkValidReturnReq(curOrder),
            child: Expanded(
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isDismissible: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    elevation: 3,
                    builder: (context) {
                      bool _isChecked = false;
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * .75,
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .6,
                                  child: CompilanceWidget('RETURN_REFUND')),
                              StatefulBuilder(
                                builder: (BuildContext context, state) =>
                                    Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CheckboxListTile(
                                      title: Text(
                                        'I have read and agree with the above Term and condition',
                                        style: TextStyles.titleFont,
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: AppColors.primeColor,
                                      // checkColor: Colors.yellow,
                                      selected: _isChecked,
                                      value: _isChecked,
                                      onChanged: (value) {
                                        state(() {
                                          _isChecked = value!;
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          OutlinedButton(
                                            child: Text("Cancel"),
                                            style: OutlinedButton.styleFrom(
                                              // primary: Colors.red,
                                              side: BorderSide(
                                                width: 2,
                                                color: Colors.red,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          ElevatedButton(
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(
                                                  fontFamily: Fonts.body,
                                                  fontSize: FontSizes.title,
                                                  color: AppColors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _isChecked
                                                  ? AppColors.primeColor
                                                  : AppColors.grey,
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              if (_isChecked) {
                                                Navigator.of(context).pop();

                                                ReturnOrderConfirmationDialog(
                                                    context,
                                                    curOrder
                                                        .userFriendlyOrderId);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  );
                },
                child: Text(
                  'Return',
                  style: TextStyles.headingFont.copyWith(color: AppColors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> EmailCancelOrder(String? orderID) async {
    const toEmail = 'hello@sbazar.app';
    String subject = 'cancel order $orderID';
    String body =
        'Hello,\n I would like to Cancel my order with the order id ${orderID.toString()}\n';

    final Uri url = Uri.parse('mailto:$toEmail?subject=$subject&body=$body');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> ReturnOrderEmail(String? orderID) async {
    const toEmail = 'hello@sbazar.app';
    String subject = 'return order $orderID';
    String body =
        'Hello,\n I would like to Return my order with the order id ${orderID.toString()}\n';

    final Uri url = Uri.parse('mailto:$toEmail?subject=$subject&body=$body');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _showCancelOrderConfirmationDialog(
      BuildContext context, String? orderID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Order Cancellation',
            style: TextStyles.titleFont,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to cancel this order?',
                  style: TextStyles.body,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                EmailCancelOrder(orderID); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> ReturnOrderConfirmationDialog(
      BuildContext context, String? orderID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Order Return',
            style: TextStyles.titleFont,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to Return this order?',
                  style: TextStyles.body,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                ReturnOrderEmail(orderID); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  checkValidMissingReq(Order order) {
    if (order.status == 'DELIVERED') {
      String updatedAt = order.metaData!.updatedAt! ?? '';
      var newDate = DateTime.now().toUtc();
      var difference = DateTime.parse(updatedAt).difference(newDate);
      if (difference.inHours > 8.0) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  checkValidCancelReq(Order order) {
    if (order.status != 'PAID' ||
        order.status != 'SHIPPED' ||
        order.status != 'DELIVERED' ||
        order.eligibleForCancellation!) {
      return true;
    } else {
      return false;
    }
  }

  bool isDateTime14DaysOld(String? dateTimeString) {
    if (dateTimeString == null) {
      return false;
    } else {
      try {
        DateTime givenDateTime = DateTime.parse(dateTimeString);
        DateTime currentDate = DateTime.now();
        Duration difference = currentDate.difference(givenDateTime);

        return difference.inDays <= 14;
      } catch (e) {
        debugPrint("$e issue in date time paerse");
        return false;
      }
    }
  }

  checkValidReturnReq(Order order) {
    //   bool isDateTime14Daysold = isDateTime14DaysOld("2023-09-08T12:00:00");
    bool isDateTime14Daysold =
        isDateTime14DaysOld(order.shipping?.lastMovement?.time);
    if (order.status == 'DELIVERED' &&
        order.shipping?.lastMovement?.status == "SHIPPED" &&
        isDateTime14Daysold) {
      return true;
    } else {
      return false;
    }
  }

  OrdeTile(BuildContext context, Order curOrder) {
    DateTime orderTime = DateTime.parse(curOrder.metaData!.createdAt!);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${TimeUtil.getFormatDateTime(orderTime, 'EEE d /MM/ yyyy')}",
                      style: TextStyles.bodyFontBold,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(),
                          color: Helper.getColor(curOrder.status)
                              .withOpacity(0.2)),
                      child: Text('${CodeHelp.titleCase(curOrder.status!)}',
                          style: TextStyles.headingFont.copyWith(
                              color: Helper.getColor(curOrder.status))),
                    ),
                  ]),
            ),
            const Divider(
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Text('Order #', style: TextStyles.headingFont),
                  Text(
                    'Order number:  ${curOrder.userFriendlyOrderId}',
                    style: TextStyles.body.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Total: ',
                    style: TextStyles.bodyFont.copyWith(color: AppColors.grey),
                  ),

                  Text(
                      '\$${curOrder.payment!.totalAmount!.toString()} ${CodeHelp.euro}',
                      style: TextStyles.headingFont),
                ],
              ),
            ),
            if (curOrder.products!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _orderProductTile(curOrder.products!, context),
              )
            ],
            const Divider(
              thickness: 1.5,
              // color: Colors.black12,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: (curOrder.status == "SHIPPED" ||
                      curOrder.status == "CANCELLED" ||
                      curOrder.status == "EXPIRED" ||
                      curOrder.status == "DELIVERED")
                  ? Align(
                      alignment: Alignment.topRight,
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        shape: StadiumBorder(),
                        onPressed: () {},
                        child: Text("Reorder"),
                      ),
                    )
                  : orderButtons(curOrder, context),
            )
            //    orderButtons(curOrder, context),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(4.0),
            //         child: Text(
            //           'You have saved ${CodeHelp.euro}${curOrder.payment!.totalSavedAmount!} and you will get ${curOrder.payment!.totalSCoinsEarned!} scoin.',
            //           style:
            //               TextStyles.bodyFontBold.copyWith(color: Colors.grey),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _orderProductTile(List<ProductOrder> e, BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          //   shrinkWrap: true,
          itemCount: e.length,
          itemBuilder: (context, index) => Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ImageBox(
                    e[index].product!.images![0],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                        shape: StadiumBorder(), color: Colors.black87),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      child: Text("x${e[index].count}",
                          style:
                              TextStyles.body.copyWith(color: AppColors.white)),
                    ),
                  )
                ],
              )),
    );
  }
}
