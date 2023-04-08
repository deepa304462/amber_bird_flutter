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
          leadingWidth: 100,
          backgroundColor: AppColors.primeColor,
          leading: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
         
          title: Column(
            children: [
              Text(
                'My Orders',
                style: TextStyles.headingFont.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),

      body: Obx(
        () => Column(
          children: [
            // AppBar(
            //   backgroundColor: AppColors.primeColor,
            //   title: Text(
            //     'Order List',
            //     style: TextStyles.headingFont.copyWith(color: Colors.white),
            //   ),
            //   centerTitle: true,
            //   leading: IconButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     icon: const Icon(
            //       Icons.arrow_back,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
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
    DateTime orderTime = DateTime.parse(curOrder!.metaData!.createdAt!);
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
                    style: TextStyles.bodyFont.copyWith(fontSize: 15),
                  ),
                ],
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Order #'),
                      Text(
                        '${curOrder.userFriendlyOrderId}',
                        style: TextStyles.headingFont
                            .copyWith(color: AppColors.primeColor),
                      ),
                    ],
                  ),
                  Text(
                      '${curOrder.products!.length} ${curOrder.products!.length > 1 ? 'products' : 'product'} ordered'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Order Status', style: TextStyles.bodyFont),
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
                          '${CodeHelp.euro}${curOrder.payment!.totalAmount!.toString()} ',
                          style: TextStyles.bodyFontBold
                              .copyWith(color: Colors.green)),
                      Text(
                        'Paid',
                        style: TextStyles.bodyFontBold
                            .copyWith(color: Colors.grey),
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
                      MaterialButton(
                        padding: const EdgeInsets.all(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.primeColor)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Modular.to.pushNamed('/order-detail',
                              arguments: {'id': curOrder.id});
                        },
                        elevation: 0,
                        child: Text(
                          'View',
                          style: TextStyles.bodyFont
                              .copyWith(color: AppColors.primeColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
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
}
