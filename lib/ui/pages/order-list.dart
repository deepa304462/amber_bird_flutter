import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/time-util.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
        ),
      ),
    );
  }

  OrderTile(BuildContext context, Order curOrder) {
    DateTime orderTime = DateTime.parse(curOrder.metaData!.createdAt!);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TimeUtil.getFormatDateTime(orderTime, 'dd MMM, yy'),
                    style: TextStyles.bodyFontBold,
                  ),
                  Text(
                    TimeUtil.getFormatDateTime(orderTime, 'hh:mm a'),
                    style: TextStyles.titleFont,
                  ),
                ],
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Order #', style: TextStyles.headingFont),
                      Text(
                        '${curOrder.userFriendlyOrderId}',
                        style: TextStyles.headingFont
                            .copyWith(color: AppColors.primeColor),
                      ),
                    ],
                  ),
                  Text(
                      '${curOrder.products!.length} ${curOrder.products!.length > 1 ? 'products' : 'product'} ordered',
                      style: TextStyles.titleFont),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Order Status', style: TextStyles.titleFont),
                  Text('${CodeHelp.titleCase(curOrder.status!)}',
                      style: TextStyles.bodyFontBold),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                          '${curOrder.payment!.totalAmount!.toString()} ${CodeHelp.euro}',
                          style: TextStyles.bodyFontBold
                              .copyWith(color: Colors.green)),
                      Text(
                        'Paid ',
                        style:
                            TextStyles.titleFont.copyWith(color: Colors.grey),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Order will be deliver soon.',
                        style: TextStyles.bodyFont.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      OutlinedButton(
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //     side: BorderSide(color: AppColors.primeColor)),
                        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Modular.to.pushNamed('/widget/order-detail',
                              arguments: {'id': curOrder.id});
                        },

                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: AppColors.primeColor),
                            ),
                          ),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: AppColors.primeColor)),
                        ),
                        child: Text(
                          'View',
                          style: TextStyles.titleFont
                              .copyWith(color: AppColors.primeColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            orderButtons(curOrder),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'You have saved ${CodeHelp.euro}${curOrder.payment!.totalSavedAmount!} and you will get ${curOrder.payment!.totalSCoinsEarned!} scoin.',
                      style:
                          TextStyles.bodyFontBold.copyWith(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderButtons(Order curOrder) {
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
                onPressed: () {},
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
                onPressed: () {},
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
    if (order.status != 'TEMPORARY_OR_CART' ||
        order.status != 'RETURNED' ||
        order.status != 'REFUND' ||
        order.status != 'CANCEL') {
      return true;
    } else {
      return false;
    }
  }

  checkValidReturnReq(Order order) {
    if (order.status == 'DELIVERED') {
      return true;
    } else {
      return false;
    }
  }
}
