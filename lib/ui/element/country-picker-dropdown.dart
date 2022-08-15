import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryPickerDropdown extends StatelessWidget {
  Function(String) callback;
  CountryPickerDropdown(this.callback);
  var dropdownvalue = '91'.obs;

  // List of items in our dropdown menu
  var items = [
    {"label": '+91', 'value': '91'},
    {"label": '+1', 'value': '1'},
    {"label": '+2', 'value': '2'},
    {"label": '+3', 'value': '3'},
    {"label": '+4', 'value': '4'},
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => items.isNotEmpty
          ? DropdownButton(
              value: dropdownvalue.value,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((items) {
                return DropdownMenuItem(
                  value: items['value'],
                  child: Text(items['label'] ?? ''),
                );
              }).toList(),
              onChanged: (String? newValue) {
                dropdownvalue.value = newValue!;
                callback(newValue);
              },
            )
          : SizedBox(),
    );
  }
}
