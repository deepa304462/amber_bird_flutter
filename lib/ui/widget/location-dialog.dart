import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/radio-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/google-address-suggest.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class LocationDialog extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
  LocationController locationController = Get.find();
  String type;
  LocationDialog(this.type, {super.key}) {
    if (this.type == 'ADD') {
      locationController.setInitialDataForNewAddress();
    } else {
      locationController.setLocation();
    }
  }

  callback(String name, String text) {
    locationController.setFielsvalue(text, name);
  }

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = false.obs;
    RxString errorMessage = ''.obs;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Obx(
            () => Container(
              color: AppColors.commonBgColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppBar(
                    backgroundColor: AppColors.primeColor,
                    leadingWidth: 50,
                    leading: IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Modular.to.navigate('../../home/main');
                            // Modular.to.pushNamed('/home/main');
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 15,
                        )),
                    title: Text(
                      '${CodeHelp.titleCase(type)} Address',
                      style:
                          TextStyles.headingFont.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     '${CodeHelp.titleCase(type)} Address',
                  //     style:
                  //         TextStyles.headingFont.copyWith(color: AppColors.primeColor),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return GoogleAddressSuggest();
                        },
                      );
                    },
                    child: Text(
                      'Click here for address autofill',
                      textAlign: TextAlign.left,
                      style: TextStyles.titleFont.copyWith(color: Colors.blue),
                    ),
                  ),
                  ITextBox(
                      'Name (Required)',
                      'name',
                      locationController.changeAddressData.value.name != null
                          ? locationController.changeAddressData.value.name
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
                      'House No (Required)',
                      'houseNo',
                      locationController.changeAddressData.value.houseNo != null
                          ? locationController.changeAddressData.value.houseNo
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
                      'Phone (Required)',
                      'phoneNumber',
                      locationController.changeAddressData.value.phoneNumber !=
                              null
                          ? locationController
                              .changeAddressData.value.phoneNumber
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
                  ITextBox(
                      'Street name (Required)',
                      'line1',
                      locationController.changeAddressData.value.line1 != null
                          ? locationController.changeAddressData.value.line1
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
                      'City (Required)',
                      'city',
                      locationController.changeAddressData.value.city != null
                          ? locationController.changeAddressData.value.city
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
                      'Zip Code',
                      'zipCode',
                      locationController.changeAddressData.value.zipCode != null
                          ? locationController.changeAddressData.value.zipCode
                              .toString()
                          : '',
                      false,
                      TextInputType.number,
                      false,
                      false,
                      callback),
                  Obx(
                    () => IRadioBox(
                        'Type',
                        'addressType',
                        locationController
                                    .changeAddressData.value.addressType !=
                                null
                            ? locationController
                                .changeAddressData.value.addressType
                                .toString()
                            : 'HOME',
                        ['HOME', 'OFFICE'],
                        false,
                        callback),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage.value,
                      style: TextStyles.body.copyWith(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.grey,
                          child: const Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                          color: AppColors.white,
                          onPressed: () async {
                            isLoading.value = true;
                            locationController.addressData.value =
                                locationController.changeAddressData.value;
                            var data;
                            errorMessage.value = '';
                            if (locationController
                                        .changeAddressData.value.name ==
                                    null ||
                                locationController
                                        .changeAddressData.value.name ==
                                    '') {
                              //  snackBarClass.showToast(context, 'Please fill House no');
                              errorMessage.value = 'Please fill name';
                              isLoading.value = false;
                              return;
                            }
                            if (locationController
                                        .changeAddressData.value.phoneNumber ==
                                    null ||
                                locationController
                                        .changeAddressData.value.phoneNumber ==
                                    '') {
                              //  snackBarClass.showToast(context, 'Please fill House no');
                              errorMessage.value = 'Please fill mobile number';
                              isLoading.value = false;
                              return;
                            } else if (locationController
                                        .changeAddressData.value.houseNo ==
                                    null ||
                                locationController
                                        .changeAddressData.value.houseNo ==
                                    '') {
                              //  snackBarClass.showToast(context, 'Please fill House no');
                              errorMessage.value = 'Please fill House no';
                              isLoading.value = false;
                              return;
                            } else if (locationController
                                    .changeAddressData.value.line1 ==
                                null) {
                              errorMessage.value = 'Please fill street name';
                              isLoading.value = false;
                              return;
                            } else if (locationController
                                        .changeAddressData.value.city ==
                                    null ||
                                locationController
                                        .changeAddressData.value.city ==
                                    '') {
                              errorMessage.value = 'Please fill city';
                              isLoading.value = false;
                              return;
                            } else if (locationController
                                        .changeAddressData.value.zipCode ==
                                    null ||
                                locationController
                                        .changeAddressData.value.zipCode ==
                                    '') {
                              errorMessage.value = 'Please fill zipcode';
                              isLoading.value = false;
                              return;
                            } else {
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
                            style: TextStyle(color: AppColors.primeColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
