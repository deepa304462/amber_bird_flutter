import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/update-password-controller.dart';
import 'package:amber_bird/ui/element/country-picker-dropdown.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassTextBox extends StatelessWidget {
  final String label;
  final String value;
  final String keyName;
  final bool iscomingFromThridParty;
  final bool isPassword;
  final bool isDisabled;
  final TextInputType keyboardType;
  Function(String) callback;
  ResetPassTextBox(
      this.label,
      this.keyName,
      this.value,
      this.iscomingFromThridParty,
      this.keyboardType,
      this.isPassword,
      this.isDisabled,
      this.callback);

  final UpdatePasswordController updatePassController = Get.find();

  @override
  Widget build(BuildContext context) {
    TextEditingController ipController = TextEditingController();
    ipController.addListener(() {
      // if (keyName == 'userName') {
      //   authController.checkValidityUsername();
      // }
      updatePassController.setResetPassvalue(ipController.text, keyName);
    });

    ipController.text = value;
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
        obscureText: isPassword,
        keyboardType: keyboardType,
        readOnly: isDisabled,
      ),
    );
  }
}
