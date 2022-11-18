 import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
 import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:amber_bird/utils/ui-style.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class AllAddressPage extends StatelessWidget {
  final Controller stateController = Get.find();
  RxList<Address> addressList = <Address>[].obs;
  @override
  Widget build(BuildContext context) {
    getAddressList() async {
      var detail =
          await OfflineDBService.get(OfflineDBService.customerInsightDetail);
      Customer cust = Customer.fromMap(detail as Map<String, dynamic>);
      addressList.value = cust.addresses!;
    }

    getAddressList();
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () {
                  Modular.to.navigate('../home/main');
                },
                icon: const Icon(Icons.arrow_back))
          ]),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: addressList.length,
                  itemBuilder: (_, index) {
                    var currentAddress = addressList[index];
                    return addressCard(
                        currentAddress, () => {});
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget addressCard(Address address, Map Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: ListTile(
            title: Text(
              address.name!,
              style: TextStyles.titleLargeBold,
            ),
            subtitle: Text(
              address.line1!,
              style: TextStyles.bodyFont,
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
