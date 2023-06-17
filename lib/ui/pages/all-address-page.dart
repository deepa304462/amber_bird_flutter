import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/widget/section-card.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

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
            AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 50,
              leadingWidth: 50,
              backgroundColor: AppColors.primeColor,
              leading: MaterialButton(
                onPressed: () {
                  // Navigator.pop(context);
                  if (Modular.to.canPop()) {
                    Modular.to.pop();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Modular.to.navigate('../../home/main');
                  }
                  // stateController.navigateToUrl('/home/main');
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Address List',
                    style: TextStyles.bodyFont.copyWith(color: Colors.white),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      locationController.changeAddressData.value = Address();
                      displayLocationDialog(context, locationController, 'ADD');
                    },
                    icon: Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                    label: Text(
                      'Add',
                      style:
                          TextStyles.bodyFont.copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //   Row(
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         icon: const Icon(
            //           Icons.arrow_back_ios,
            //           size: 15,
            //         ),
            //       ),
            //       Text(
            //         'Address List',
            //         style: TextStyles.headingFont,
            //       ),
            //     ],
            //   ),
            //   TextButton.icon(
            //     onPressed: () {
            //       locationController.changeAddressData.value = Address();
            //       displayLocationDialog(context, locationController, 'ADD');
            //     },
            //     icon: Icon(
            //       Icons.add,
            //       color: AppColors.primeColor,
            //     ),
            //     label: Text(
            //       'Add Address',
            //       style:
            //           TextStyles.bodyFont.copyWith(color: AppColors.primeColor),
            //     ),
            //   ),
            // ]),
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
                    stateController.navigateToUrl('/widget/cart');
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
