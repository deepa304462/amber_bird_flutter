import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/google-address-suggest.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationDialog extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
  LocationController locationController = Get.find();
  String type;
  LocationDialog(this.type, {super.key}) {}

  callback(String name, String text) {
    locationController.setFielsvalue(text, name);
  }

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = false.obs;
    RxString errorMessage = ''.obs;
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        color: AppColors.white,
        child:  SingleChildScrollView(
        child: Center(
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   const SizedBox(
                    height: 15,
                  ),
                  Text(
                    '${CodeHelp.titleCase(type)} Address',
                    style: TextStyles.bodyWhiteLarge
                        .copyWith(color: AppColors.primeColor),
                  ),
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
                      style: TextStyles.titleLarge
                          .copyWith(color: AppColors.primeColor),
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
                      'Line1 (Required)',
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
                      'Line2 (Required)',
                      'line2',
                      locationController.changeAddressData.value.line2 != null
                          ? locationController.changeAddressData.value.line2
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
                      'Country',
                      'country',
                      locationController.changeAddressData.value.country != null
                          ? locationController.changeAddressData.value.country
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
                      locationController.changeAddressData.value.landMark !=
                              null
                          ? locationController.changeAddressData.value.landMark
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
                      'Land Area',
                      'localArea',
                      locationController.changeAddressData.value.localArea !=
                              null
                          ? locationController.changeAddressData.value.localArea
                              .toString()
                          : '',
                      false,
                      TextInputType.text,
                      false,
                      false,
                      callback),

                  //     const SizedBox(
                  //   height: 10,
                  // ),
                  // ITextBox(
                  //     'Type',
                  //     'addressType',
                  //     locationController.changeAddressData.value.addressType !=
                  //             null
                  //         ? locationController
                  //             .changeAddressData.value.addressType
                  //             .toString()
                  //         : '',
                  //     false,
                  //     TextInputType.text,
                  //     false,
                  //     false,
                  //     callback),

                  const SizedBox(
                    height: 10,
                  ),
                  ITextBox(
                      'Directional Comment',
                      'directionComment',
                      locationController
                                  .changeAddressData.value.directionComment !=
                              null
                          ? locationController
                              .changeAddressData.value.directionComment
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    errorMessage.value,
                    style: TextStyles.bodyWhite,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          isLoading.value = true;
                          locationController.addressData.value =
                              locationController.changeAddressData.value;
                          var data;
                          errorMessage.value = '';
                          if (locationController.changeAddressData.value.name ==
                                  null ||
                              locationController.changeAddressData.value.name ==
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
                              null) {
                            //  snackBarClass.showToast(context, 'Please fill House no');
                            errorMessage.value = 'Please fill House no';
                            isLoading.value = false;
                            return;
                          } else if (locationController
                                  .changeAddressData.value.line1 ==
                              null) {
                            errorMessage.value = 'Please fill line1';
                            isLoading.value = false;
                            return;
                          } else if (locationController
                                  .changeAddressData.value.line2 ==
                              null) {
                            errorMessage.value = 'Please fill line2';
                            isLoading.value = false;
                            return;
                          } else if (locationController
                                  .changeAddressData.value.city ==
                              null) {
                            errorMessage.value = 'Please fill city';
                            isLoading.value = false;
                            return;
                          } else if (locationController
                                  .changeAddressData.value.country ==
                              null) {
                            errorMessage.value = 'Please fill country';
                            isLoading.value = false;
                            return;
                          } else if (locationController
                                  .changeAddressData.value.name ==
                              null) {
                            errorMessage.value = 'Please fill name';
                            isLoading.value = false;
                            return;
                          } else {
                            if (type == 'ADD') {
                              data = await locationController.addAddressCall();
                            } else {
                              data = await locationController.editAddressCall();
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
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "DISMISS",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
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
