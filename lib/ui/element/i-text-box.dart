import 'package:amber_bird/controller/auth-controller.dart';
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
  final TextInputType keyboardType;
  Function(String) callback;
  ITextBox(this.label, this.keyName,this.value, this.iscomingFromThridParty,
      this.keyboardType, this.isPassword, this.callback);

        final AuthController authController = Get.find();

//   @override
//   State<StatefulWidget> createState() {
//     return _ITextBox();
//   }
// }

// class _ITextBox extends State<ITextBox> {
  @override
  Widget build(BuildContext context) {
    TextEditingController ipController = new TextEditingController();
    ipController.addListener(() {  
      authController.setFielsvalue(ipController.text, keyName);
    });

    ipController.text = value;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primeColor)),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
        controller: ipController,
        obscureText: isPassword,
        keyboardType: keyboardType,
      ),
    );
  }
}
