import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            IconButton(
              onPressed: () {
                // Modular.to.navigate('../home/main');
                Modular.to.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Text(
              'Address List',
              style: TextStyles.headingFont,
            ),
            TextButton.icon(
              onPressed: () {
                locationController.changeAddressData.value = Address();
                _displayDialog(context, locationController, 'ADD');
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Address'),
            ),
          ]),
          Container(
            height: MediaQuery.of(context).size.height * 0.70,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primeColor),
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
                        context, locationController, index, currentAddress, () {
                      locationController.addressData.value = currentAddress; 
                      Modular.to.navigate('/home/cart');
                      return {};
                    });
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
        return Material(
          type: MaterialType.transparency,
          // make sure that the overlay content is not cut off
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(20),
                color: AppColors.primeColor,
                child: Center(
                  child: Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '$type Address',
                          style: TextStyles.bodyWhiteLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'Name',
                            'name',
                            locationController.changeAddressData.value.name !=
                                    null
                                ? locationController
                                    .changeAddressData.value.name
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'House No',
                            'houseNo',
                            locationController.changeAddressData.value.houseNo !=
                                    null
                                ? locationController
                                    .changeAddressData.value.houseNo
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'Phone',
                            'phoneNumber',
                            locationController
                                        .changeAddressData.value.phoneNumber !=
                                    null
                                ? locationController
                                    .changeAddressData.value.phoneNumber
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'Line1',
                            'line1',
                            locationController.changeAddressData.value.line1 !=
                                    null
                                ? locationController
                                    .changeAddressData.value.line1
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'Line2',
                            'line2',
                            locationController.changeAddressData.value.line2 !=
                                    null
                                ? locationController
                                    .changeAddressData.value.line2
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'City',
                            'city',
                            locationController.changeAddressData.value.city !=
                                    null
                                ? locationController
                                    .changeAddressData.value.city
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'Country',
                            'country',
                            locationController
                                        .changeAddressData.value.country !=
                                    null
                                ? locationController
                                    .changeAddressData.value.country
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'Land Mark',
                            'landMark',
                            locationController
                                        .changeAddressData.value.landMark !=
                                    null
                                ? locationController
                                    .changeAddressData.value.landMark
                                    .toString()
                                : '',
                            false,
                            TextInputType.text,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ITextBox(
                            'zip Code',
                            'zipCode',
                            locationController
                                        .changeAddressData.value.zipCode !=
                                    null
                                ? locationController
                                    .changeAddressData.value.zipCode
                                    .toString()
                                : '',
                            false,
                            TextInputType.number,
                            false,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(errorMessage.value,style: TextStyles.bodyWhite,),
                         const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            isLoading.value = true;
                            locationController.addressData.value =
                                locationController.changeAddressData.value;
                            var data;
                            errorMessage.value = '';
                            if(locationController.changeAddressData.value.houseNo == null){
                              //  snackBarClass.showToast(context, 'Please fill House no');
                               errorMessage.value ='Please fill House no';
                               isLoading.value = false;
                              return;
                            }else{
                              if (type == 'ADD') {
                                data =
                                    await locationController.addAddressCall();
                              } else {
                                data =
                                    await locationController.editAddressCall();
                              }
                              if (data['status'] == 'success') {}
                              isLoading.value = false;
                              snackBarClass.showToast(context, data['msg']);
                              Navigator.of(context).pop();
                            }
                           
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
          ),
        );
      },
    );
  }

  callback(String name, String text) {
    locationController.setFielsvalue(text, name);
  }
}
