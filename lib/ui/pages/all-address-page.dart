import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/widget/location-dialog.dart';
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
                  _displayDialog(context, locationController, 'ADD');
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
                    Modular.to.navigate('/home/cart');
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

  Widget addressCard(
      BuildContext context,
      LocationController locationController,
      int index,
      Address address,
      Map Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: ListTile(
            title: Text(
              address.name!,
              style: TextStyles.headingFont,
            ),
            subtitle: FitText(
              '${address.line1!} ${address.zipCode}',
              style: TextStyles.bodyFont,
            ),
            trailing: IconButton(
              onPressed: () {
                locationController.seelctedIndexToEdit.value = index;
                print(index);
                locationController.changeAddressData.value = address;
                _displayDialog(context, locationController, 'Edit');
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, LocationController locationController,
      String type) {
    RxBool isLoading = false.obs;
    RxString errorMessage = ''.obs;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return LocationDialog(type);
      },
    );
  }

  // callback(String name, String text) {
  //   locationController.setFielsvalue(text, name);
  // }
}
