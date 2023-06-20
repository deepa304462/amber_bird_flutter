import 'package:amber_bird/controller/google-address-suggest-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/radio-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class LocationDialog extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
  LocationController locationController = Get.find();
  late GoogleAddressSuggestController controller;
  TextEditingController _textController = TextEditingController();
  RxBool searchedAdd = false.obs;
  String type;
  LocationDialog(this.type, {super.key}) {
    controller = ControllerGenerator.create(GoogleAddressSuggestController(),
        tag: 'googleAddressSuggestController');
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
    searchedAdd.value = false;
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
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 50,
                    leadingWidth: 50,
                    backgroundColor: AppColors.primeColor,
                    leading: IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Modular.to.navigate('../../home/main');
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 15,
                        )),
                    title: Text(
                      '${CodeHelp.titleCase(type)} Address',
                      style: TextStyles.bodyFont.copyWith(color: Colors.white),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  !searchedAdd.value
                      ? SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: "Search your home address",
                                      hintText: "Type home address",
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            _textController.clear();
                                            controller.addressSuggestions
                                                .clear();
                                          },
                                          child: const Icon(Icons.clear))),
                                  controller: _textController,
                                  onChanged: (String changedText) {
                                    controller.search(changedText,
                                        locationController.pinCode.value);
                                  },
                                ),
                                Expanded(
                                  child: Obx(
                                    () => ListView(
                                      shrinkWrap: true,
                                      children: controller.addressSuggestions
                                          .map(
                                            (element) => TextButton(
                                              onPressed: () {
                                                locationController
                                                    .updateCustomerAddress(
                                                        element);
                                                searchedAdd.value = true;
                                                // Modular.to.pop(element);
                                              },
                                              style: const ButtonStyle(
                                                  alignment:
                                                      Alignment.centerLeft),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${element['formatted_address']}',
                                                  style: TextStyles.bodyFont,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  // MaterialButton(
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return GoogleAddressSuggest();
                  //       },
                  //     );
                  //   },
                  //   child: Text(
                  //     'Click here for address autofill',
                  //     textAlign: TextAlign.left,
                  //     style: TextStyles.titleFont.copyWith(color: Colors.blue),
                  //   ),
                  // ),
                  searchedAdd.value
                      ? Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          8,
                                  child: ITextBox(
                                      'Name (Required)',
                                      'name',
                                      locationController.changeAddressData.value
                                                  .name !=
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          8,
                                  child: ITextBox(
                                      'Phone (Required)',
                                      'phoneNumber',
                                      locationController.changeAddressData.value
                                                  .phoneNumber !=
                                              null
                                          ? locationController.changeAddressData
                                              .value.phoneNumber
                                              .toString()
                                          : '',
                                      false,
                                      TextInputType.number,
                                      false,
                                      false,
                                      callback),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width / 4) - 8,
                                child: ITextBox(
                                    'House No (Required)',
                                    'houseNo',
                                    locationController.changeAddressData.value
                                                .houseNo !=
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
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width *
                                        3 /
                                        4) -
                                    8,
                                child: ITextBox(
                                    'Street name (Required)',
                                    'line1',
                                    locationController.changeAddressData.value
                                                .line1 !=
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
                              )
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width / 2) - 8,
                                child: ITextBox(
                                    'City (Required)',
                                    'city',
                                    locationController
                                                .changeAddressData.value.city !=
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
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width / 2) - 8,
                                child: ITextBox(
                                    'Zip Code',
                                    'zipCode',
                                    locationController.changeAddressData.value
                                                .zipCode !=
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
                              )
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          8,
                                  child: ITextBox(
                                      'Country',
                                      'country',
                                      locationController.changeAddressData.value
                                                  .country !=
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          8,
                                  child: Obx(
                                    () => IRadioBox(
                                        'Type',
                                        'addressType',
                                        locationController.changeAddressData
                                                    .value.addressType !=
                                                null
                                            ? locationController
                                                .changeAddressData
                                                .value
                                                .addressType
                                                .toString()
                                            : 'HOME',
                                        ['HOME', 'OFFICE'],
                                        false,
                                        callback),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                errorMessage.value,
                                style:
                                    TextStyles.body.copyWith(color: Colors.red),
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
                                          locationController
                                              .changeAddressData.value;
                                      var data;
                                      errorMessage.value = '';
                                      if (locationController.changeAddressData
                                                  .value.name ==
                                              null ||
                                          locationController.changeAddressData
                                                  .value.name ==
                                              '') {
                                        //  snackBarClass.showToast(context, 'Please fill House no');
                                        errorMessage.value = 'Please fill name';
                                        isLoading.value = false;
                                        return;
                                      }
                                      if (locationController.changeAddressData
                                                  .value.phoneNumber ==
                                              null ||
                                          locationController.changeAddressData
                                                  .value.phoneNumber ==
                                              '') {
                                        //  snackBarClass.showToast(context, 'Please fill House no');
                                        errorMessage.value =
                                            'Please fill mobile number';
                                        isLoading.value = false;
                                        return;
                                      } else if (locationController
                                                  .changeAddressData
                                                  .value
                                                  .houseNo ==
                                              null ||
                                          locationController.changeAddressData
                                                  .value.houseNo ==
                                              '') {
                                        //  snackBarClass.showToast(context, 'Please fill House no');
                                        errorMessage.value =
                                            'Please fill House no';
                                        isLoading.value = false;
                                        return;
                                      } else if (locationController
                                              .changeAddressData.value.line1 ==
                                          null) {
                                        errorMessage.value =
                                            'Please fill street name';
                                        isLoading.value = false;
                                        return;
                                      } else if (locationController
                                                  .changeAddressData
                                                  .value
                                                  .city ==
                                              null ||
                                          locationController.changeAddressData
                                                  .value.city ==
                                              '') {
                                        errorMessage.value = 'Please fill city';
                                        isLoading.value = false;
                                        return;
                                      } else if (locationController
                                                  .changeAddressData
                                                  .value
                                                  .zipCode ==
                                              null ||
                                          locationController.changeAddressData
                                                  .value.zipCode ==
                                              '') {
                                        errorMessage.value =
                                            'Please fill zipcode';
                                        isLoading.value = false;
                                        return;
                                      } else {
                                        if (type == 'ADD') {
                                          data = await locationController
                                              .addAddressCall();
                                        } else {
                                          data = await locationController
                                              .editAddressCall();
                                        }
                                        if (data['status'] == 'success') {}
                                        isLoading.value = false;
                                        snackBarClass.showToast(
                                            context, data['msg']);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text(
                                      isLoading.value ? "Loading" : 'Submit',
                                      style: TextStyle(
                                          color: AppColors.primeColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
