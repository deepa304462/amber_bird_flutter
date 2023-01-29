import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationTextBox extends StatelessWidget {
  final String label;
  final String value;
  final String keyName;
  final TextInputType keyboardType;
  Function(String) callback;
  LocationTextBox(
      this.label, this.keyName, this.value, this.keyboardType, this.callback);

  final LocationController locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    TextEditingController ipController = TextEditingController();
    ipController.addListener(() {
      locationController.setFielsvalue(ipController.text, keyName);
    });
    // if (keyboardType == TextInputType.number)
    //   ipController.text = int.parse(value);
    // else
      // ipController.text = value;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primeColor)),
      child: TextField(
        style: TextStyles.title,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
        controller: ipController,
        keyboardType: keyboardType,
      ),
    );
  }
}
