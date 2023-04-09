import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/widget/location-dialog.dart';
import 'package:amber_bird/ui/widget/section-card.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../widget/fit-text.dart';

class AllAddressPage extends StatelessWidget {
  final Controller stateController = Get.find();
  RxList<Address> addressList = <Address>[].obs;
  LocationController locationController = Get.find();
  @override
  Widget build(BuildContext context) {
    getAddressList() async {
      var detail = await OfflineDBService.get(OfflineDBService.customerInsight);
      Customer cust = Customer.fromMap(detail as Map<String, dynamic>);
      addressList.value = cust.addresses!;
    }

    return Obx(
      () {
        getAddressList();
        return ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Address List',
                    style: TextStyles.headingFont,
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  locationController.changeAddressData.value = Address();
                  displayLocationDialog(context, locationController, 'ADD');
                },
                icon: Icon(
                  Icons.add,
                  color: AppColors.primeColor,
                ),
                label: Text(
                  'Add Address',
                  style:
                      TextStyles.bodyFont.copyWith(color: AppColors.primeColor),
                ),
              ),
            ]),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addressList.length,
              itemBuilder: (_, index) {
                var currentAddress = addressList[index];
                return addressCard(
                  context,
                  locationController,
                  index,
                  currentAddress,
                  () {
                    locationController.addressData.value = currentAddress;
                    locationController.pinCode.value = currentAddress.zipCode!;
                    // Modular.to.navigate('../cart');
                    stateController.navigateToUrl('../cart');
                    return {};
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }



  // callback(String name, String text) {
  //   locationController.setFielsvalue(text, name);
  // }
}
