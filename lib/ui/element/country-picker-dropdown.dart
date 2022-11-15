import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/services/client-service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryPickerDropdown extends StatelessWidget {
  Function(String) callback;
  String value;
  CountryPickerDropdown(this.value, this.callback);
  var dropdownvalue = '91'.obs;

  // List of items in our dropdown menu
  var dropdownItems = [].obs;

  getCountryCode() async {
    print(dropdownvalue.value);
    var payload = {"configId": "countries", "providerId": "sbazar"};
    var resp =
        await ClientService.post(path: 'FieldMap/search', payload: payload);
    if (resp.statusCode == 200) {
      log(resp.data.toString());
      // items.value =[];
      List<Map<String, String>> arr = [];
      resp.data.forEach((elem) {
        var data = jsonDecode(elem['extraData']);
        arr.add({'label': data['label'], 'value': data['value']});
      });
      dropdownItems.value = arr;
      callback(dropdownvalue
          .value); // (arr).map((e) =>  (e as Map<String, dynamic>)).toList();
      print(dropdownItems.value.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    dropdownvalue.value = value ?? '91';
    getCountryCode();
    return Obx(
      () => dropdownItems.isNotEmpty
          ? DropdownButton(
              value: dropdownvalue.value,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: dropdownItems.map((items) {
                return DropdownMenuItem(
                  value: items['value'],
                  child: Text(items['label'] ?? ''),
                );
              }).toList(),
              onChanged: (dynamic newValue) {
                dropdownvalue.value = newValue!;
                callback(newValue);
              },
            )
          : const SizedBox(),
    );
  }
}
