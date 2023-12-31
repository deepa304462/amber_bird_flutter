import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/ui/element/country-picker-dropdown.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
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
    ipController.selection = TextSelection.fromPosition(
        TextPosition(offset: ipController.text.length));
  }

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (keyName != 'mobile') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          style: TextStyles.titleFont.copyWith(color: AppColors.DarkGrey),

          decoration: InputDecoration(
              labelText: label,
              // border: OutlineInputBorder(),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              labelStyle:
                  TextStyles.headingFont.copyWith(color: AppColors.DarkGrey)),
          onChanged: ((textChanged) {
            // ipController.text = textChanged;
            callback(keyName, textChanged);
          }),
          obscureText: isPassword,
          keyboardType: keyboardType,
          // readOnly: isDisabled,
          controller: ipController,
        ),
      );
    } else {
      ipController.text =
          value.split('-').length > 1 ? value.split('-')[1] : value;
      return Container(
        height: 55,
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
          color: Colors.transparent,
          // borderRadius: BorderRadius.circular(5),
          // border: Border.all(color: AppColors.DarkDrey)
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 80,
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
                style: TextStyles.titleFont.copyWith(color: AppColors.DarkGrey),
                // style: TextStyles.title,
                maxLength: 15,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.DarkGrey),
                    ),
                    labelStyle: TextStyles.headingFont
                        .copyWith(color: AppColors.DarkGrey),
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
