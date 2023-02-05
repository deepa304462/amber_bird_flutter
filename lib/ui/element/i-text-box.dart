import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/ui/element/country-picker-dropdown.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ITextBox extends StatelessWidget {
  final String label;
  final String value;
  final String keyName;
  final bool iscomingFromThridParty;
  final bool isPassword;
  final bool isDisabled;
  final TextInputType keyboardType;
  TextEditingController ipController = TextEditingController();
  Function callback;
  ITextBox(this.label, this.keyName, this.value, this.iscomingFromThridParty,
      this.keyboardType, this.isPassword, this.isDisabled, this.callback) {
    ipController.text = value;

    //   ipController.addListener(() {
    //   print("CONTROLLER: $ipController");
    // });
  }

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (keyName != 'mobile') {
      return Container(
        height: 55,
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.white)),
        child: TextField(
          style: TextStyles.title,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle: TextStyles.headingFont),
          onChanged: ((textChanged) {
            callback(keyName, textChanged);
          }),
          obscureText: isPassword,
          keyboardType: keyboardType,
          // readOnly: isDisabled,
          // controller: ipController,
        ),
      );
    } else {
      ipController.text =
          value.split('-').length > 1 ? value.split('-')[1] : value;
      return Container(
        height: 55,
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.white)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              child: CountryPickerDropdown(
                value.split('-').length > 1
                    ? value.split('-')[0]
                    : (authController.fieldValue['countryCode'].toString() != ''
                        ? authController.fieldValue['countryCode'].toString()
                        : '91'),
                (country) {
                  //countryCode
                  authController.setFielsvalue(country, 'countryCode');
                },
              ),
            ),
            Expanded(
              child: TextField(
                style: TextStyles.title,
                maxLength: 15,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyles.headingFont,
                    labelText: label,
                    counterText: ""),
                obscureText: isPassword,
                onChanged: ((textChanged) {
                  callback(keyName, textChanged);
                }),
                readOnly: isDisabled,
                keyboardType: keyboardType,
              ),
            ),
          ],
        ),
      );
    }
  }
}
