import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/element/location-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
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

    return Obx(() {
      getAddressList();
      return Container(
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
                    return addressCard(context, locationController, index,
                        currentAddress, () => {});
                  },
                ),
              ],
            ),
          ),
        ]),
      );
    });
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
                style: TextStyles.titleLargeBold,
              ),
              subtitle: Text(
                address.line1!,
                style: TextStyles.bodyFont,
              ),
              trailing: IconButton(
                  onPressed: () {
                    locationController.seelctedIndexToEdit.value = index;
                    print(index);
                    locationController.changeAddressData.value =
                        locationController.addressData.value;
                    _displayDialog(context, locationController);
                  },
                  icon: Icon(Icons.edit))),
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, LocationController locationController) {
    RxBool isLoading = false.obs;
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
        return Material(
          type: MaterialType.transparency,
          // make sure that the overlay content is not cut off
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Center(
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LocationTextBox(
                          'Name',
                          'name',
                          locationController.changeAddressData.value.name
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'Line1',
                          'line1',
                          locationController.changeAddressData.value.line1
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'Line2',
                          'line2',
                          locationController.changeAddressData.value.line2
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'City',
                          'city',
                          locationController.changeAddressData.value.city
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'Country',
                          'country',
                          locationController.changeAddressData.value.country
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'LandMark',
                          'landMark',
                          locationController.changeAddressData.value.landMark
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'ZipCode',
                          'zipCode',
                          locationController.changeAddressData.value.zipCode
                              .toString(),
                          TextInputType.number,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          isLoading.value = true;
                          locationController.addressData.value =
                              locationController.changeAddressData.value;
                          var data = await locationController.editAddressCall();
                          if (data['status'] == 'success') {}
                          isLoading.value = false;

                          snackBarClass.showToast(context, data['msg']);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          isLoading.value ? "Loading" : 'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "DISMISS",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  callback(String p1) {}
}
